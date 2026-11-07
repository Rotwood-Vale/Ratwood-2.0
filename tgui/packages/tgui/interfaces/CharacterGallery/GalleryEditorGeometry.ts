const OPERATION_TIMEOUT_MS = 1000;
/** How long a resize that stopped short of its target must stay quiet to count as finished */
const RESIZE_SETTLE_MS = 150;
/** Must match the editor column's 440px fallback in CharacterGallery.scss */
const EDITOR_MIN_WIDTH = 440;

/**
 * Resizes only this Gallery window when its editor opens or folds, preserving its position and height.
 *
 * One operation runs at a time, from reading the size until the window answers with a resize. Whatever
 * was asked for meanwhile runs after it, so each read sees the size the last write left
 */
export class GalleryEditorGeometry {
  private disposed = false;
  private wanted = false;
  private expanded = false;
  private base = 0;
  private panelWidth = 0;
  private finish?: (runLatest: boolean) => void;
  /** The page's width when the size was written, so a resize that only changed the height is not the answer */
  private writtenFrom?: number;
  /** The native width before an outstanding write, which a later read may still return */
  private writtenSize = 0;
  /** The width in window pixels the size was written as */
  private writtenTo = 0;
  private settling = 0;

  private resized = () => {
    if (
      this.writtenFrom === undefined ||
      window.innerWidth === this.writtenFrom
    ) {
      return;
    }
    window.clearTimeout(this.settling);
    if (
      Math.abs(
        window.innerWidth * (window.devicePixelRatio || 1) - this.writtenTo,
      ) <= 1
    ) {
      this.completeResize();
      return;
    }
    // Short of the target, which may still be on its way or be as far as the screen allows
    this.settling = window.setTimeout(
      () => this.completeResize(),
      RESIZE_SETTLE_MS,
    );
  };

  private completeResize() {
    window.clearTimeout(this.settling);
    this.writtenFrom = undefined;
    if (this.finish) {
      this.finish(true);
    } else {
      this.apply();
    }
  }

  constructor(
    private scale = true,
    private getContent?: () => HTMLElement | null,
  ) {
    window.addEventListener('resize', this.resized);
  }

  private measureExpansion() {
    const content = this.getContent?.();
    const ledger = content?.querySelector<HTMLElement>(
      '.CharacterGallery__ledger',
    );
    const editor = ledger?.querySelector<HTMLElement>(
      '.CharacterGallery__editor',
    );
    const framing = editor?.querySelector<HTMLElement>(
      '.CharacterGallery__framing',
    );
    if (!content || !ledger || !editor || !framing) {
      return 480;
    }
    const rem =
      parseFloat(window.getComputedStyle(document.documentElement).fontSize) ||
      16;
    const overview = Math.min(content.clientWidth, 48 * rem);
    content.style.setProperty('--gallery-overview-width', `${overview}px`);
    content.style.removeProperty('--gallery-editor-width');
    if (!editor.offsetWidth) {
      return 480;
    }
    const gap = parseFloat(window.getComputedStyle(ledger).columnGap) || 0;
    // Capped at the column's minimum, as in a wide window the column also holds the spare room
    const width = Math.ceil(
      Math.min(editor.offsetWidth, EDITOR_MIN_WIDTH) +
        Math.max(0, framing.scrollWidth - framing.clientWidth) +
        gap,
    );
    content.style.setProperty('--gallery-editor-width', `${width}px`);
    return Math.max(0, width + gap - (content.clientWidth - overview));
  }

  private holdLayout(expanding: boolean) {
    const content = this.getContent?.();
    const held = expanding
      ? 'CharacterGallery--expanding'
      : 'CharacterGallery--folding';
    content?.classList.add(held);
    return () => content?.classList.remove(held);
  }

  /** A request asks again after a write the window never answered, as it may have ignored it */
  private async apply(requested = false) {
    const target = this.wanted;
    if (
      this.disposed ||
      this.finish ||
      (target === this.expanded &&
        (!requested || this.writtenFrom === undefined))
    ) {
      return;
    }
    const extra = target ? this.measureExpansion() : 0;
    const release = this.holdLayout(target);
    let timer = 0;
    const finish = (runLatest: boolean) => {
      window.clearTimeout(timer);
      this.finish = undefined;
      release();
      if (runLatest) {
        this.apply();
      }
    };
    this.finish = finish;
    // Unwritten means no answer came for the read either, and only a new request should ask again
    timer = window.setTimeout(
      () => finish(this.expanded === target),
      OPERATION_TIMEOUT_MS,
    );
    const size = await Byond.winget(Byond.windowId, 'size');
    if (this.finish !== finish) {
      return;
    }
    // Asked for the opposite meanwhile, which is the state the window is already in
    if (this.wanted !== target || !(size?.x > 0 && size?.y > 0)) {
      finish(false);
      return;
    }
    if (this.writtenFrom !== undefined) {
      // A timeout releases the layout hold, but the native write may still arrive after this read
      if (target !== this.expanded && size.x === this.writtenSize) {
        finish(false);
        return;
      }
      // The window moved since the write it never answered, so it took that write
      if (target === this.expanded && size.x !== this.writtenSize) {
        this.writtenFrom = undefined;
        finish(false);
        return;
      }
    }
    window.clearTimeout(this.settling);
    this.writtenFrom = undefined;
    const ratio = window.devicePixelRatio || 1;
    let width: number;
    if (target) {
      const screen = window.screen as Screen & { availLeft?: number };
      const room =
        ((screen.availLeft ?? 0) + screen.availWidth - window.screenLeft) *
        ratio;
      width = Math.round(
        Math.min(
          size.x + (this.panelWidth || extra * (this.scale ? ratio : 1)),
          Math.max(size.x, room),
        ),
      );
      this.base = size.x;
    } else {
      if (size.x > this.base) {
        this.panelWidth = size.x - this.base;
      }
      width = Math.min(size.x, this.base);
    }
    this.expanded = target;
    if (width === size.x) {
      finish(true);
      return;
    }
    this.writtenFrom = window.innerWidth;
    this.writtenSize = size.x;
    this.writtenTo = width;
    Byond.winset(Byond.windowId, { size: `${width}x${size.y}` });
  }

  async setExpanded(expanded: boolean) {
    this.wanted = expanded;
    await this.apply(true);
  }

  dispose() {
    this.disposed = true;
    window.removeEventListener('resize', this.resized);
    window.clearTimeout(this.settling);
    this.writtenFrom = undefined;
    this.finish?.(false);
  }
}
