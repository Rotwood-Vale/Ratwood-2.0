import { describe, expect, it, spyOn } from 'bun:test';
import DOMPurify from 'dompurify';

import { serializeMessage } from './model';
import { getSavedMessageHtml, withoutExamineIcons } from './savedHtml';

const sprite =
  '<img data-examine-icon class="icon" src="data:image/png;base64,AAAA">';

describe('saved examine sprites', () => {
  it('removes only marked sprites and preserves names, links and other images', () => {
    const html = `${sprite}<a href="byond://?src=1">a steel mask</a><img class="chat_headshot" src="portrait.png"><img class="icon" src="language.png">`;
    const saved = withoutExamineIcons(html);
    expect(saved).not.toContain('AAAA');
    expect(saved).not.toContain('data-examine-icon');
    expect(saved).toContain('a steel mask');
    expect(saved).toContain('byond://?src=1');
    expect(saved).toContain('portrait.png');
    expect(saved).toContain('language.png');
  });

  it('retains tooltip content and player text including quotes and entities', () => {
    const html = `<span data-component="TooltipHTML" data-html="Armor &amp; coverage">${sprite}They&#39;re &lt;fine&gt;.</span>`;
    const template = document.createElement('template');
    template.innerHTML = withoutExamineIcons(html);
    expect(template.content.textContent).toBe("They're <fine>.");
    expect(
      template.content.querySelector('span')?.getAttribute('data-html'),
    ).toBe('Armor & coverage');
  });

  it('does not parse ordinary messages or mistake written marker text for an icon', () => {
    expect(withoutExamineIcons('plain & unchanged')).toBe('plain & unchanged');
    expect(withoutExamineIcons('I wrote data-examine-icon')).toBe(
      'I wrote data-examine-icon',
    );
  });

  it('saves a separate copy without mutating the live message or dropping metadata', () => {
    const message = {
      html: `${sprite}a sword`,
      type: 'info',
      times: 3,
      createdAt: 123,
    };
    const saved = serializeMessage(message);
    expect(message.html).toContain('AAAA');
    expect(saved.html).not.toContain('AAAA');
    expect(saved.html).toContain('a sword');
    expect(saved.type).toBe(message.type);
    expect(saved.times).toBe(3);
    expect(saved.createdAt).toBe(123);
  });

  it('reuses parsed saved HTML and refreshes it when the source changes', () => {
    const message = { html: `${sprite}a sword` };
    const parser = spyOn(document, 'createElement');
    try {
      expect(getSavedMessageHtml(message)).toContain('a sword');
      expect(getSavedMessageHtml(message)).toContain('a sword');
      expect(parser).toHaveBeenCalledTimes(1);
      message.html = `${sprite}an axe`;
      expect(getSavedMessageHtml(message)).toContain('an axe');
      expect(parser).toHaveBeenCalledTimes(2);
    } finally {
      parser.mockRestore();
    }
  });

  it('handles text-only messages and multiple marked images', () => {
    expect(serializeMessage({ text: 'Hello', type: 'local' }).text).toBe(
      'Hello',
    );
    expect(serializeMessage({ text: 'Hello' }).html).toBeUndefined();
    expect(withoutExamineIcons(`${sprite}A ${sprite}B`)).toBe('A B');
  });

  it('keeps the marker through chat sanitization and restores a readable saved message', () => {
    const live = DOMPurify.sanitize(`${sprite}<b>a sword</b>`);
    expect(live).toContain('data-examine-icon');
    const saved = serializeMessage({ html: live, type: 'info' });
    expect(DOMPurify.sanitize(saved.html)).toBe(' <b>a sword</b>'.trimStart());
    expect(live).toContain('AAAA');
  });

  it('removes examine images from the actual log export without altering live nodes', async () => {
    const { chatRenderer } = await import('./renderer');
    const node = document.createElement('div');
    node.innerHTML = `${sprite}<b>a sword</b><img src="portrait.png">`;
    const previousMessages = chatRenderer.visibleMessages;
    const context = globalThis as unknown as {
      Byond?: { saveBlob: (blob: Blob) => void };
    };
    const previousByond = context.Byond;
    let exported: Blob | undefined;
    context.Byond = {
      saveBlob: (blob) => {
        exported = blob;
      },
    };
    chatRenderer.visibleMessages = [{ node }];
    try {
      chatRenderer.saveToDisk();
      const html = await exported!.text();
      expect(html).not.toContain('AAAA');
      expect(html).toContain('<b>a sword</b>');
      expect(html).toContain('portrait.png');
      expect(node.innerHTML).toContain('AAAA');
    } finally {
      chatRenderer.visibleMessages = previousMessages;
      context.Byond = previousByond;
    }
  });
});
