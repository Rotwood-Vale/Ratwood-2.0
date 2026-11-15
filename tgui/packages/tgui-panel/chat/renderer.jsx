/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createRoot } from 'react-dom/client';
import { TooltipHTML } from 'tgui/components/TooltipHTML';
import { createLogger } from 'tgui/logging';
import { Tooltip } from 'tgui-core/components';
import { EventEmitter } from 'tgui-core/events';
import { classes } from 'tgui-core/react';

import { RollTooltip } from '../chat_components/RollTooltip';
import {
  COMBINE_MAX_MESSAGES,
  COMBINE_MAX_TIME_WINDOW,
  IMAGE_RETRY_DELAY,
  IMAGE_RETRY_LIMIT,
  IMAGE_RETRY_MESSAGE_AGE,
  MAX_CHAT_MESSAGES,
  MESSAGE_PRUNE_INTERVAL,
  MESSAGE_TYPE_INTERNAL,
  MESSAGE_TYPE_UNKNOWN,
  MESSAGE_TYPES,
} from './constants';
import { canPageAcceptType, createMessage, isSameMessage } from './model';
import { highlightNode, linkifyNode } from './replaceInTextNode';
import { withoutExamineIcons } from './savedHtml';

const logger = createLogger('chatRenderer');

// We consider this as the smallest possible scroll offset
// that is still trackable.
const SCROLL_TRACKING_TOLERANCE = 24;

// List of injectable component names to the actual type
export const TGUI_CHAT_COMPONENTS = {
  Tooltip,
  TooltipHTML,
  RollTooltip,
};

// List of injectable attibute names mapped to their proper prop
// We need this because attibutes don't support lowercase names
export const TGUI_CHAT_ATTRIBUTES_TO_PROPS = {
  position: 'position',
  content: 'content',
  html: 'html',
  dice: 'dice',
  labels: 'labels',
  sides: 'sides',
  outcome: 'outcome',
  outcomes: 'outcomes',
  stats: 'stats',
  footers: 'footers',
};

const findNearestScrollableParent = (startingNode) => {
  const body = document.body;
  let node = startingNode;
  while (node && node !== body) {
    // Works even before the first message makes the pane overflow.
    if (/^(auto|scroll)$/.test(getComputedStyle(node).overflowY)) {
      return node;
    }
    node = node.parentNode;
  }
  return document.scrollingElement || document.documentElement;
};

const createHighlightNode = (text, color) => {
  const node = document.createElement('span');
  node.className = 'Chat__highlight';
  node.setAttribute('style', `background-color:${color}`);
  node.textContent = text;
  return node;
};

const createMessageNode = () => {
  const node = document.createElement('div');
  node.className = 'ChatMessage';
  return node;
};

const createReconnectedNode = () => {
  const node = document.createElement('div');
  node.className = 'Chat__reconnected';
  return node;
};

const handleImageError = (e) => {
  setTimeout(() => {
    /** @type {HTMLImageElement} */
    const node = e.target;
    if (!node) {
      return;
    }
    const attempts = parseInt(node.getAttribute('data-reload-n'), 10) || 0;
    if (attempts >= IMAGE_RETRY_LIMIT) {
      logger.error(`failed to load an image after ${attempts} attempts`);
      return;
    }
    const src = node.src;
    node.src = null;
    node.src = `${src}#${attempts}`;
    node.setAttribute('data-reload-n', attempts + 1);
  }, IMAGE_RETRY_DELAY);
};

/**
 * Assigns a "times-repeated" badge to the message.
 */
const updateMessageBadge = (message) => {
  const { node, times } = message;
  if (!node || !times) {
    // Nothing to update
    return;
  }
  const foundBadge = node.querySelector('.Chat__badge');
  const badge = foundBadge || document.createElement('div');
  badge.textContent = times;
  badge.className = classes(['Chat__badge', 'Chat__badge--animate']);
  requestAnimationFrame(() => {
    badge.className = 'Chat__badge';
  });
  if (!foundBadge) {
    node.appendChild(badge);
  }
};

export class ChatRenderer {
  constructor() {
    /** @type {boolean} */
    this.loaded = false;
    /** @type {HTMLElement} */
    this.rootNode = null;
    this.queue = [];
    this.messages = [];
    this.visibleMessages = [];
    this.page = null;
    this.events = new EventEmitter();
    // Scroll handler
    /** @type {HTMLElement} */
    this.scrollNode = null;
    this.scrollTracking = true;
    this.lastScrollHeight = 0;
    this.lastClientHeight = 0;
    this.scrollBoundsDirty = true;
    this.scrollInputUntil = 0;
    this.scrollInputTop = 0;
    this.scrollInputAway = false;
    this.scrollTouchY = null;
    this.scrollPointerDown = false;
    this.mountScrollTimer = null;
    this.handleScrollInput = (event) => {
      if (event?.ctrlKey && event.deltaY !== undefined) {
        return;
      }
      // Allow the browser to apply wheel, keyboard and touch scrolling first.
      this.scrollInputUntil = Date.now() + 250;
      this.scrollInputTop = this.scrollNode?.scrollTop || 0;
      let direction = event?.deltaY || 0;
      if (event?.key) {
        direction =
          ['ArrowUp', 'PageUp', 'Home'].includes(event.key) ||
          (event.key === ' ' && event.shiftKey)
            ? -1
            : 1;
      }
      const touchY = event?.touches?.[0]?.clientY;
      if (touchY !== undefined) {
        direction = this.scrollTouchY === null ? 0 : this.scrollTouchY - touchY;
        this.scrollTouchY = touchY;
      }
      if (direction) {
        this.scrollInputAway = direction < 0;
        if (this.scrollInputAway) {
          // Yield before native scrolling or a queued message/layout callback.
          this.setScrollTracking(false);
        } else if (
          event?.deltaY > 0 &&
          !this.scrollTracking &&
          (this.scrollBoundsDirty ||
            this.lastScrollHeight -
              this.scrollInputTop -
              this.lastClientHeight <
              SCROLL_TRACKING_TOLERANCE)
        ) {
          // A wheel at the bottom may not produce another native scroll event.
          this.updateScrollTracking();
        }
      }
    };
    this.resetScrollInput = () => {
      this.scrollInputUntil = 0;
      this.scrollPointerDown = false;
      this.scrollTouchY = null;
    };
    this.handleScrollKey = (event) => {
      if (
        !event.target.closest?.('input, textarea, select, [contenteditable]') &&
        [
          'ArrowUp',
          'ArrowDown',
          'PageUp',
          'PageDown',
          'Home',
          'End',
          ' ',
        ].includes(event.key)
      ) {
        this.handleScrollInput(event);
      }
    };
    this.handleScrollPointerDown = () => {
      // Includes dragging the scrollbar and selecting text into the history.
      this.scrollPointerDown = true;
      this.handleScrollInput();
    };
    this.handleScrollPointerUp = () => {
      if (!this.scrollPointerDown) {
        return;
      }
      this.scrollPointerDown = false;
      this.scrollTouchY = null;
      this.scrollInputUntil = Date.now() + 250;
    };
    this.handleScroll = () => {
      this.updateScrollTracking();
      if (this.scrollTracking) {
        this.scrollToBottom();
      }
    };
    this.ensureScrollTracking = () => {
      if (this.scrollTracking) {
        // Resolve any player movement before an observer or queued callback
        // can overwrite it with a programmatic scroll.
        this.handleScroll();
      }
    };
    this.handleScrollResize = () => {
      this.scrollBoundsDirty = true;
      if (
        !this.scrollTracking &&
        !this.scrollInputAway &&
        Date.now() < this.scrollInputUntil
      ) {
        // A resize can reach the bottom before its observer reports new bounds.
        this.updateScrollTracking();
      }
      this.ensureScrollTracking();
    };
    // Periodic message pruning
    setInterval(() => this.pruneMessages(), MESSAGE_PRUNE_INTERVAL);
  }

  updateScrollTracking() {
    const node = this.scrollNode;
    if (!node) {
      return;
    }
    const height = node.scrollHeight;
    const clientHeight = node.clientHeight;
    const scrollTop = node.scrollTop;
    const layoutChanged =
      height !== this.lastScrollHeight ||
      clientHeight !== this.lastClientHeight;
    this.lastScrollHeight = height;
    this.lastClientHeight = clientHeight;
    this.scrollBoundsDirty = false;
    const atBottom =
      height - scrollTop - clientHeight < SCROLL_TRACKING_TOLERANCE;
    const userInput =
      this.scrollPointerDown || Date.now() < this.scrollInputUntil;
    if (
      layoutChanged &&
      atBottom &&
      !this.scrollInputAway &&
      !this.scrollPointerDown
    ) {
      // Shrinking content can clamp the viewport upward to its new bottom.
      this.scrollInputTop = scrollTop;
    }
    if (userInput && scrollTop < this.scrollInputTop) {
      this.scrollInputAway = true;
      this.scrollInputTop = scrollTop;
      this.setScrollTracking(false);
      return;
    }
    if (this.scrollInputAway) {
      // A scrollbar drag can reverse direction without another wheel/key event.
      if (
        this.scrollPointerDown &&
        !layoutChanged &&
        scrollTop > this.scrollInputTop
      ) {
        this.scrollInputAway = false;
      } else {
        return;
      }
    }
    if (atBottom) {
      this.setScrollTracking(true);
    } else if (
      userInput &&
      (!layoutChanged || scrollTop < this.scrollInputTop)
    ) {
      this.setScrollTracking(false);
    }
  }

  isReady() {
    return this.loaded && this.rootNode && this.page;
  }

  mount(node) {
    this.unmount();
    // Mount existing root node on top of the new node
    if (this.rootNode) {
      node.appendChild(this.rootNode);
    }
    // Initialize the root node
    else {
      this.rootNode = node;
    }
    // Find scrollable parent
    this.scrollNode = findNearestScrollableParent(this.rootNode);
    this.scrollNode.addEventListener('scroll', this.handleScroll);
    this.scrollNode.addEventListener('wheel', this.handleScrollInput, {
      passive: true,
    });
    this.scrollNode.addEventListener('touchmove', this.handleScrollInput, {
      passive: true,
    });
    this.scrollNode.addEventListener('touchstart', this.handleScrollInput, {
      passive: true,
    });
    this.scrollNode.addEventListener('keydown', this.handleScrollKey);
    this.scrollNode.addEventListener(
      'pointerdown',
      this.handleScrollPointerDown,
    );
    window.addEventListener('pointerup', this.handleScrollPointerUp);
    window.addEventListener('pointercancel', this.handleScrollPointerUp);
    window.addEventListener('blur', this.resetScrollInput);
    document.addEventListener('visibilitychange', this.resetScrollInput);
    this.resizeObserver = new ResizeObserver(this.handleScrollResize);
    this.resizeObserver.observe(this.rootNode);
    this.resizeObserver.observe(this.scrollNode);
    this.mountScrollTimer = setTimeout(() => {
      this.mountScrollTimer = null;
      this.ensureScrollTracking();
    });
    // Flush the queue
    this.tryFlushQueue();
  }

  unmount() {
    if (this.mountScrollTimer !== null) {
      clearTimeout(this.mountScrollTimer);
      this.mountScrollTimer = null;
    }
    this.resizeObserver?.disconnect();
    this.scrollNode?.removeEventListener('scroll', this.handleScroll);
    this.scrollNode?.removeEventListener('wheel', this.handleScrollInput);
    this.scrollNode?.removeEventListener('touchmove', this.handleScrollInput);
    this.scrollNode?.removeEventListener('touchstart', this.handleScrollInput);
    this.scrollNode?.removeEventListener('keydown', this.handleScrollKey);
    this.scrollNode?.removeEventListener(
      'pointerdown',
      this.handleScrollPointerDown,
    );
    window.removeEventListener('pointerup', this.handleScrollPointerUp);
    window.removeEventListener('pointercancel', this.handleScrollPointerUp);
    window.removeEventListener('blur', this.resetScrollInput);
    document.removeEventListener('visibilitychange', this.resetScrollInput);
    this.scrollNode = null;
    this.scrollBoundsDirty = true;
    this.resetScrollInput();
  }

  onStateLoaded() {
    this.loaded = true;
    this.tryFlushQueue();
  }

  tryFlushQueue() {
    if (this.isReady() && this.queue.length > 0) {
      this.processBatch(this.queue);
      this.queue = [];
    }
  }

  assignStyle(style = {}) {
    this.scrollBoundsDirty = true;
    for (const key of Object.keys(style)) {
      this.rootNode.style.setProperty(key, style[key]);
    }
  }

  setHighlight(highlightSettings, highlightSettingById) {
    this.highlightParsers = null;
    if (!highlightSettings) {
      return;
    }
    highlightSettings.map((id) => {
      const setting = highlightSettingById[id];
      const text = setting.highlightText;
      const highlightColor = setting.highlightColor;
      const highlightWholeMessage = setting.highlightWholeMessage;
      const matchWord = setting.matchWord;
      const matchCase = setting.matchCase;
      const allowedRegex = /^[a-zа-яё0-9_\-$/^[\s\]\\]+$/gi;
      const regexEscapeCharacters = /[!#$%^&*)(+=.<>{}[\]:;'"|~`_\-\\/]/g;
      const lines = String(text)
        .split(',')
        .map((str) => str.trim())
        .filter(
          (str) =>
            // Must be longer than one character
            str &&
            str.length > 1 &&
            // Must be alphanumeric (with some punctuation)
            (allowedRegex.test(str) ||
              (str.charAt(0) === '/' && str.charAt(str.length - 1) === '/')) &&
            // Reset lastIndex so it does not mess up the next word
            ((allowedRegex.lastIndex = 0) || true),
        );
      let highlightWords;
      let highlightRegex;
      // Nothing to match, reset highlighting
      if (lines.length === 0) {
        return;
      }
      const regexExpressions = [];
      // Organize each highlight entry into regex expressions and words
      for (let line of lines) {
        // Regex expression syntax is /[exp]/
        if (line.charAt(0) === '/' && line.charAt(line.length - 1) === '/') {
          const expr = line.substring(1, line.length - 1);
          // Check if this is more than one character
          if (/^(\[.*\]|\\.|.)$/.test(expr)) {
            continue;
          }
          regexExpressions.push(expr);
        } else {
          // Lazy init
          if (!highlightWords) {
            highlightWords = [];
          }
          // We're not going to let regex characters fuck up our RegEx operation.
          line = line.replace(regexEscapeCharacters, '\\$&');

          highlightWords.push(line);
        }
      }
      const regexStr = regexExpressions.join('|');
      const flags = `g${matchCase ? '' : 'i'}`;
      // We wrap this in a try-catch to ensure that broken regex doesn't break
      // the entire chat.
      try {
        // setting regex overrides matchword
        if (regexStr) {
          highlightRegex = new RegExp(`(${regexStr})`, flags);
        } else {
          const pattern = `${matchWord ? '\\b' : ''}(${highlightWords.join(
            '|',
          )})${matchWord ? '\\b' : ''}`;
          highlightRegex = new RegExp(pattern, flags);
        }
      } catch {
        // We just reset it if it's invalid.
        highlightRegex = null;
      }
      // Lazy init
      if (!this.highlightParsers) {
        this.highlightParsers = [];
      }
      this.highlightParsers.push({
        highlightWords,
        highlightRegex,
        highlightColor,
        highlightWholeMessage,
      });
    });
  }

  setScrollTracking(value) {
    if (value !== this.scrollTracking) {
      this.scrollTracking = value;
      this.events.emit('scrollTrackingChanged', value);
      logger.debug('tracking', value);
    }
  }

  scrollToBottom() {
    if (!this.scrollNode) {
      return;
    }
    this.scrollInputAway = false;
    this.setScrollTracking(true);
    // scrollHeight is always bigger than scrollTop and is
    // automatically clamped to the valid range.
    this.scrollNode.scrollTop = this.scrollNode.scrollHeight;
    this.lastScrollHeight = this.scrollNode.scrollHeight;
    this.lastClientHeight = this.scrollNode.clientHeight;
    this.scrollBoundsDirty = false;
  }

  changePage(page) {
    if (!this.isReady()) {
      this.page = page;
      this.tryFlushQueue();
      return;
    }
    this.page = page;
    // Fast clear of the root node
    this.scrollBoundsDirty = true;
    this.rootNode.textContent = '';
    this.visibleMessages = [];
    // Re-add message nodes
    const fragment = document.createDocumentFragment();
    let node;
    for (const message of this.messages) {
      if (canPageAcceptType(page, message.type)) {
        node = message.node;
        fragment.appendChild(node);
        this.visibleMessages.push(message);
      }
    }
    if (node) {
      this.rootNode.appendChild(fragment);
      node.scrollIntoView();
    }
  }

  getCombinableMessage(predicate) {
    const now = Date.now();
    const len = this.visibleMessages.length;
    const from = len - 1;
    const to = Math.max(0, len - COMBINE_MAX_MESSAGES);
    for (let i = from; i >= to; i--) {
      const message = this.visibleMessages[i];

      const matches =
        // Is not an internal message
        !message.type.startsWith(MESSAGE_TYPE_INTERNAL) &&
        // Text payload must fully match
        isSameMessage(message, predicate) &&
        // Must land within the specified time window
        now < message.createdAt + COMBINE_MAX_TIME_WINDOW;
      if (matches) {
        return message;
      }
    }
    return null;
  }

  processBatch(batch, options = {}) {
    const { prepend, notifyListeners = true } = options;
    const now = Date.now();
    // Queue up messages until chat is ready
    if (!this.isReady()) {
      if (prepend) {
        this.queue = [...batch, ...this.queue];
      } else {
        this.queue = [...this.queue, ...batch];
      }
      return;
    }
    // Insert messages
    this.scrollBoundsDirty = true;
    const fragment = document.createDocumentFragment();
    const countByType = {};
    let node;
    for (const payload of batch) {
      const message = createMessage(payload);
      // Combine messages
      const combinable = this.getCombinableMessage(message);
      if (combinable) {
        combinable.times = (combinable.times || 1) + 1;
        updateMessageBadge(combinable);
        continue;
      }
      // Reuse message node
      if (message.node) {
        node = message.node;
      }
      // Reconnected
      else if (message.type === 'internal/reconnected') {
        node = createReconnectedNode();
      }
      // Create message node
      else {
        node = createMessageNode();
        // Payload is plain text
        if (message.text) {
          node.textContent = message.text;
        }
        // Payload is HTML
        else if (message.html) {
          node.innerHTML = message.html;
        } else {
          logger.error('Error: message is missing text payload', message);
        }
        // Get all nodes in this message that want to be rendered like jsx
        const nodes = node.querySelectorAll('[data-component]');
        for (let i = 0; i < nodes.length; i++) {
          const childNode = nodes[i];
          const targetName = childNode.getAttribute('data-component');
          // Let's pull out the attibute info we need
          const outputProps = {};
          for (let j = 0; j < childNode.attributes.length; j++) {
            const attribute = childNode.attributes[j];

            let working_value = attribute.nodeValue;
            // We can't do the "if it has no value it's truthy" trick
            // Because getAttribute returns "", not null. Hate IE
            if (working_value === '$true') {
              working_value = true;
            } else if (working_value === '$false') {
              working_value = false;
            } else if (targetName !== 'RollTooltip' && !isNaN(working_value)) {
              const parsed_float = parseFloat(working_value);
              if (!isNaN(parsed_float)) {
                working_value = parsed_float;
              }
            }

            let canon_name = attribute.nodeName.replace('data-', '');
            // html attributes don't support upper case chars, so we need to map
            canon_name = TGUI_CHAT_ATTRIBUTES_TO_PROPS[canon_name];
            outputProps[canon_name] = working_value;
          }
          const oldHtml = { __html: childNode.innerHTML };
          while (childNode.firstChild) {
            childNode.removeChild(childNode.firstChild);
          }
          const Element = TGUI_CHAT_COMPONENTS[targetName];

          const reactRoot = createRoot(childNode);

          /* eslint-disable react/no-danger */
          // Gracefully handle missing components (cross-server compatibility)
          if (Element) {
            reactRoot.render(
              <Element {...outputProps}>
                <span dangerouslySetInnerHTML={oldHtml} />
              </Element>,
              childNode,
            );
          } else {
            // Fallback: just render the inner content without the component wrapper
            reactRoot.render(
              <span dangerouslySetInnerHTML={oldHtml} />,
              childNode,
            );
          }
        }

        // Highlight text
        if (!message.avoidHighlighting && this.highlightParsers) {
          this.highlightParsers.map((parser) => {
            const highlighted = highlightNode(
              node,
              parser.highlightRegex,
              parser.highlightWords,
              (text) => createHighlightNode(text, parser.highlightColor),
            );
            if (highlighted && parser.highlightWholeMessage) {
              node.className += ' ChatMessage--highlighted';
            }
          });
        }
        // Linkify text
        const linkifyNodes = node.querySelectorAll('.linkify');
        for (let i = 0; i < linkifyNodes.length; ++i) {
          linkifyNode(linkifyNodes[i]);
        }
        // Assign an image error handler
        if (now < message.createdAt + IMAGE_RETRY_MESSAGE_AGE) {
          const imgNodes = node.querySelectorAll('img');
          for (let i = 0; i < imgNodes.length; i++) {
            const imgNode = imgNodes[i];
            imgNode.addEventListener('error', handleImageError);
          }
        }
      }
      // Store the node in the message
      message.node = node;
      // Query all possible selectors to find out the message type
      if (!message.type) {
        const typeDef = MESSAGE_TYPES.find(
          (typeDef) => typeDef.selector && node.querySelector(typeDef.selector),
        );
        message.type = typeDef?.type || MESSAGE_TYPE_UNKNOWN;
      }
      updateMessageBadge(message);
      if (!countByType[message.type]) {
        countByType[message.type] = 0;
      }
      countByType[message.type] += 1;
      // TODO: Detect duplicates
      this.messages.push(message);
      if (canPageAcceptType(this.page, message.type)) {
        fragment.appendChild(node);
        this.visibleMessages.push(message);
      }
    }
    if (node) {
      const firstChild = this.rootNode.childNodes[0];
      if (prepend && firstChild) {
        this.rootNode.insertBefore(fragment, firstChild);
      } else {
        this.rootNode.appendChild(fragment);
      }
    }
    // A combined message can add a badge line without adding a message node.
    if (this.scrollTracking && batch.length > 0) {
      setTimeout(this.ensureScrollTracking);
    }
    // Notify listeners that we have processed the batch
    if (notifyListeners) {
      this.events.emit('batchProcessed', countByType);
    }
  }

  pruneMessages() {
    if (!this.isReady()) {
      return;
    }
    // Delay pruning because user is currently interacting
    // with chat history
    if (!this.scrollTracking) {
      logger.debug('pruning delayed');
      return;
    }
    // Visible messages
    {
      const messages = this.visibleMessages;
      const fromIndex = Math.max(0, messages.length - MAX_CHAT_MESSAGES);
      if (fromIndex > 0) {
        this.visibleMessages = messages.slice(fromIndex);
        for (let i = 0; i < fromIndex; i++) {
          const message = messages[i];
          this.rootNode.removeChild(message.node);
          // Mark this message as pruned
          message.node = 'pruned';
        }
        // Remove pruned messages from the message array

        this.messages = this.messages.filter(
          (message) => message.node !== 'pruned',
        );
        // Removing old messages can move the browser's scroll anchor upward.
        // Pruning only runs while following, so keep the viewport at the end.
        this.scrollToBottom();
        logger.log(`pruned ${fromIndex} visible messages`);
      }
    }
    // All messages
    {
      const fromIndex = Math.max(0, this.messages.length - MAX_CHAT_MESSAGES);
      if (fromIndex > 0) {
        this.messages = this.messages.slice(fromIndex);
        logger.log(`pruned ${fromIndex} stored messages`);
      }
    }
  }

  rebuildChat() {
    if (!this.isReady()) {
      return;
    }
    // Make a copy of messages
    const fromIndex = Math.max(0, this.messages.length - MAX_CHAT_MESSAGES);
    const messages = this.messages.slice(fromIndex);
    // Remove existing nodes
    for (const message of messages) {
      message.node = undefined;
    }
    // Fast clear of the root node
    this.rootNode.textContent = '';
    this.messages = [];
    this.visibleMessages = [];
    // Repopulate the chat log
    this.processBatch(messages, {
      notifyListeners: false,
    });
  }

  /**
   * @clearChat
   * @copyright 2023
   * @author Cheffie
   * @link https://github.com/CheffieGithub
   * @license MIT
   */
  clearChat() {
    const messages = this.visibleMessages;
    this.visibleMessages = [];
    for (let i = 0; i < messages.length; i++) {
      const message = messages[i];
      this.rootNode.removeChild(message.node);
      // Mark this message as pruned
      message.node = 'pruned';
    }
    // Remove pruned messages from the message array
    this.messages = this.messages.filter(
      (message) => message.node !== 'pruned',
    );
    logger.log(`Cleared chat`);
  }

  saveToDisk() {
    // Compile currently loaded stylesheets as CSS text
    let cssText = '';
    const styleSheets = document.styleSheets;
    for (let i = 0; i < styleSheets.length; i++) {
      const cssRules = styleSheets[i].cssRules;
      for (let i = 0; i < cssRules.length; i++) {
        const rule = cssRules[i];
        if (rule && typeof rule.cssText === 'string') {
          cssText += `${rule.cssText}\n`;
        }
      }
    }
    cssText += 'body, html { background-color: #141414 }\n';
    // Compile chat log as HTML text
    let messagesHtml = '';
    for (const message of this.visibleMessages) {
      if (message.node) {
        messagesHtml += `${withoutExamineIcons(message.node.outerHTML)}\n`;
      }
    }
    // Create a page

    const pageHtml =
      '<!doctype html>\n' +
      '<html>\n' +
      '<head>\n' +
      '<title>SS13 Chat Log</title>\n' +
      '<style>\n' +
      cssText +
      '</style>\n' +
      '</head>\n' +
      '<body>\n' +
      '<div class="Chat">\n' +
      messagesHtml +
      '</div>\n' +
      '</body>\n' +
      '</html>\n';
    // Create and send a nice blob
    const blob = new Blob([pageHtml], { type: 'text/plain' });
    const timestamp = new Date()
      .toISOString()
      .substring(0, 19)
      .replace(/[-:]/g, '')
      .replace('T', '-');
    Byond.saveBlob(blob, `ss13-chatlog-${timestamp}.html`, '.html');
  }
}

// Make chat renderer global so that we can continue using the same
// instance after hot code replacement.
if (!window.__chatRenderer__) {
  window.__chatRenderer__ = new ChatRenderer();
}

/** @type {ChatRenderer} */
export const chatRenderer = window.__chatRenderer__;
