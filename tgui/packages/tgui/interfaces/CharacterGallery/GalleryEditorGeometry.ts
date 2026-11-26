import {
  fitWindowToWorkArea,
  nativeWindowSize,
  readWorkArea,
  type WindowBounds,
  type WorkArea,
} from '../../windowWorkArea';

const OPERATION_TIMEOUT_MS = 1000;
/** How long a resize that stopped short of its target must stay quiet to count as finished */
const RESIZE_SETTLE_MS = 150;
/** Must match the editor column's 440px fallback in CharacterGallery.scss */
const EDITOR_MIN_WIDTH = 440;
/** Preferred page width for the art Edit dialog's settings and framing columns */
const DIALOG_WIDTH = 1000;
/** The extra width asked for the headshot editor while its column is not laid out to be measured */
const UNMEASURED_EDITOR_WIDTH = 480;

/** What the window widens for: the headshot editor beside the overview, or the art Edit dialog's crop column */
type Expansion = 'editor' | 'dialog';
type AppliedBounds = { before: WindowBounds; applied: WindowBounds };
const GALLERY = 0;
const EDITING = 1;
const PREVIEWING = 2;

const readArtworkBounds = async () => {
  const {
    pos,
    'is-maximized': maximized,
    'inner-size': inner,
    'outer-size': outer,
  } = (await Byond.winget(Byond.windowId, [
    'pos',
    'is-maximized',
    'inner-size',
    'outer-size',
  ]).catch(() => undefined)) ?? {};
  if (
    maximized === true ||
    maximized === 'true' ||
    !Number.isFinite(pos?.x) ||
    !Number.isFinite(pos?.y) ||
    !(inner?.x > 0 && inner?.y > 0 && outer?.x > 0 && outer?.y > 0)
  ) {
    return null;
  }
  const ratio = window.devicePixelRatio || 1;
  const current: WindowBounds = {
    pos: [pos.x, pos.y],
    size: [outer.x, outer.y],
  };
  const screenPos: WindowBounds['pos'] = [window.screenLeft, window.screenTop];
  return {
    current,
    frame: [outer.x - inner.x, outer.y - inner.y] as [number, number],
    screenPos,
    workArea: readWorkArea(window.screen, ratio, screenPos, current.pos),
  };
};

/** How many CSS pixels wider the window can grow on its monitor, moving left as it must, or 0 if it cannot */
export const growableWidth = async () => {
  const bounds = await readArtworkBounds();
  if (!bounds) return 0;
  return (
    Math.max(0, bounds.workArea.size[0] - bounds.current.size[0]) /
    (window.devicePixelRatio || 1)
  );
};

/**
 * Resizes the Gallery for its editors and fits artwork expansions within the monitor work area.
 *
 * One operation runs at a time, from reading the size until the window answers with a resize. Whatever
 * was asked for meanwhile runs after it, so each read sees the size the last write left
 */
export class GalleryEditorGeometry {
  private disposed = false;
  private wanted = GALLERY;
  private wantedKind: Expansion = 'editor';
  private level = GALLERY;
  private priorLevel = GALLERY;
  /** What the window last widened for, as only the editor's width is kept for the next time */
  private kind: Expansion = 'editor';
  /** The previous native width of the gallery before the headshot editor opened */
  private base = 0;
  private dialogBounds?: AppliedBounds;
  private previewBounds?: AppliedBounds;
  /** The CSS pixels the Side Preview adds to the window's width */
  private previewGrowth?: number;
  private onLayoutSettled?: () => void;
  private panelWidth = 0;
  private finish?: (runLatest: boolean) => void;
  private written?: {
    axis: 'x' | 'y';
    viewport: number;
    native: number;
    target: number;
  };
  private settling = 0;
  private artworkResize?: () => void;

  private resized = () => {
    if (this.artworkResize) {
      this.artworkResize();
      return;
    }
    const written = this.written;
    if (!written) return;
    const dimension =
      written.axis === 'x' ? window.innerWidth : window.innerHeight;
    if (dimension === written.viewport) {
      return;
    }
    window.clearTimeout(this.settling);
    if (
      Math.abs(dimension * (window.devicePixelRatio || 1) - written.target) <= 1
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
    this.written = undefined;
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
      return UNMEASURED_EDITOR_WIDTH;
    }
    const rem =
      parseFloat(window.getComputedStyle(document.documentElement).fontSize) ||
      16;
    const overview = Math.min(content.clientWidth, 48 * rem);
    content.style.setProperty('--gallery-overview-width', `${overview}px`);
    content.style.removeProperty('--gallery-editor-width');
    if (!editor.offsetWidth) {
      return UNMEASURED_EDITOR_WIDTH;
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

  /** Keep the editor and the preview on separate resize steps */
  private nextLevel() {
    return this.level + Math.sign(this.wanted - this.level);
  }

  private settleLayout() {
    const settled = this.onLayoutSettled;
    this.onLayoutSettled = undefined;
    if (!this.disposed) settled?.();
  }

  private availableWidth() {
    const screen = window.screen as Screen & { availLeft?: number };
    return (screen.availLeft ?? 0) + screen.availWidth - window.screenLeft;
  }

  private async applyArtwork(target: number, from: number, preview: boolean) {
    const expanding = target > from;
    const boundsKey = preview ? 'previewBounds' : 'dialogBounds';
    const saved = this[boundsKey];
    const release = preview ? undefined : this.holdLayout(expanding);
    const advance = () => {
      this.level = target;
      if (!expanding) this[boundsKey] = undefined;
      if (!preview) this.kind = 'dialog';
    };
    const finish = (runLatest: boolean) => {
      window.clearTimeout(timer);
      window.clearTimeout(this.settling);
      this.artworkResize = undefined;
      this.finish = undefined;
      release?.();
      if (runLatest) {
        if (this.nextLevel() === target) advance();
        this.apply();
      }
    };
    if (!expanding && !saved) {
      advance();
      release?.();
      this.apply();
      return;
    }
    this.finish = finish;
    const timer = window.setTimeout(() => finish(true), OPERATION_TIMEOUT_MS);
    const bounds = await readArtworkBounds();
    if (this.finish !== finish) return;
    if (this.nextLevel() !== target || !bounds) {
      finish(true);
      return;
    }

    const { current, frame, screenPos } = bounds;
    // The Side Preview only widens the window, so its height and top stay even when taller than the screen
    const workArea: WorkArea = preview
      ? {
          origin: [bounds.workArea.origin[0], undefined],
          size: [bounds.workArea.size[0], 0],
        }
      : bounds.workArea;
    const ratio = window.devicePixelRatio || 1;
    const viewport = [window.innerWidth, window.innerHeight];
    let next: WindowBounds;
    if (expanding) {
      const growWidth = preview
        ? Math.ceil((this.previewGrowth ?? 0) * ratio)
        : Math.max(
            0,
            Math.round(DIALOG_WIDTH * (this.scale ? ratio : 1)) -
              (current.size[0] - frame[0]),
          );
      const requested: WindowBounds = {
        pos: current.pos,
        size: [current.size[0] + growWidth, current.size[1]],
      };
      next = fitWindowToWorkArea(requested, workArea);
      this[boundsKey] = { before: current, applied: next };
    } else {
      // A manually changed dimension or position takes precedence over our saved bounds.
      next = { pos: [...current.pos], size: [...current.size] };
      if (saved) {
        for (const axis of [0, 1] as const) {
          if (Math.abs(current.size[axis] - saved.applied.size[axis]) <= 1) {
            next.size[axis] = saved.before.size[axis];
          }
          if (current.pos[axis] === saved.applied.pos[axis]) {
            next.pos[axis] = saved.before.pos[axis];
          }
        }
      }
      next = fitWindowToWorkArea(next, workArea);
    }
    const changes: Record<string, string> = {};
    const moved = next.pos.some((value, axis) => value !== current.pos[axis]);
    if (moved) {
      changes.pos = next.pos.join(',');
    }
    const sizeChanged = next.size.some(
      (value, axis) => value !== current.size[axis],
    );
    if (sizeChanged) {
      changes.size = nativeWindowSize(next.size, frame);
      const expected = next.size.map(
        (value, axis) => viewport[axis] + (value - current.size[axis]) / ratio,
      );
      this.artworkResize = () => {
        const actual = [window.innerWidth, window.innerHeight];
        if (actual.every((value, axis) => value === viewport[axis])) return;
        window.clearTimeout(this.settling);
        if (
          actual.every((value, axis) => Math.abs(value - expected[axis]) <= 1)
        ) {
          finish(true);
          return;
        }
        this.settling = window.setTimeout(() => {
          if (expanding && (window.devicePixelRatio || 1) === ratio) {
            // An intermediate size can become final when the native window stops resizing.
            for (const axis of [0, 1] as const) {
              next.size[axis] =
                current.size[axis] +
                Math.round((actual[axis] - viewport[axis]) * ratio);
            }
          }
          finish(true);
        }, RESIZE_SETTLE_MS);
      };
    }
    advance();
    if (Object.keys(changes).length) Byond.winset(Byond.windowId, changes);
    if (!sizeChanged && moved) {
      // Position changes do not emit resize events.
      const started = Date.now();
      const movedIntoPlace = () => {
        const displayed = [window.screenLeft, window.screenTop];
        if (
          Date.now() - started >= RESIZE_SETTLE_MS ||
          displayed.every(
            (value, axis) =>
              Math.abs(
                value -
                  screenPos[axis] -
                  (next.pos[axis] - current.pos[axis]) / ratio,
              ) <= 1,
          )
        ) {
          finish(true);
          return;
        }
        this.settling = window.setTimeout(movedIntoPlace, 16);
      };
      movedIntoPlace();
    } else if (!sizeChanged) {
      finish(true);
    }
  }

  /** A request asks again after a write the window never answered, as it may have ignored it */
  private async apply(requested = false) {
    const target = this.nextLevel();
    if (this.disposed || this.finish) {
      return;
    }
    if (target === this.level && (!requested || !this.written)) {
      this.settleLayout();
      return;
    }
    const from = target === this.level ? this.priorLevel : this.level;
    const kind = target === this.level ? this.kind : this.wantedKind;
    const preview = target === PREVIEWING || from === PREVIEWING;
    const expanding = target > from;
    if (preview || (expanding ? kind : this.kind) === 'dialog') {
      await this.applyArtwork(target, from, preview);
      return;
    }
    const extraWidth = expanding ? this.measureExpansion() : 0;
    const release = this.holdLayout(expanding);
    let timer = 0;
    const finish = (runLatest: boolean) => {
      window.clearTimeout(timer);
      this.finish = undefined;
      release?.();
      if (runLatest) {
        this.apply();
      } else {
        this.settleLayout();
      }
    };
    this.finish = finish;
    // Retry after a stalled read only if a new transition is needed.
    timer = window.setTimeout(
      () => finish(this.level === target || this.nextLevel() !== target),
      OPERATION_TIMEOUT_MS,
    );
    const size = await Byond.winget(Byond.windowId, 'size').catch(
      () => undefined,
    );
    if (this.finish !== finish) {
      return;
    }
    if (!(size?.x > 0 && size?.y > 0)) {
      finish(this.nextLevel() !== target);
      return;
    }
    if (this.nextLevel() !== target) {
      finish(true);
      return;
    }
    if (this.written) {
      // A timeout releases the layout hold, but the native write may still arrive after this read
      const nativeChanged = size[this.written.axis] !== this.written.native;
      if (target !== this.level && !nativeChanged) {
        finish(false);
        return;
      }
      // The window moved since the write it never answered, so it took that write
      if (target === this.level && nativeChanged) {
        this.written = undefined;
        finish(false);
        return;
      }
    }
    window.clearTimeout(this.settling);
    this.written = undefined;
    const ratio = window.devicePixelRatio || 1;
    const resizeScale = this.scale ? ratio : 1;
    let width = size.x;
    if (expanding) {
      const room = this.availableWidth() * ratio;
      const panel = kind === 'editor' ? this.panelWidth : 0;
      width = Math.round(
        Math.min(
          size.x + (panel || extraWidth * resizeScale),
          Math.max(size.x, room),
        ),
      );
      this.base = size.x;
      this.kind = kind;
    } else {
      if (this.kind === 'editor' && size.x > this.base) {
        this.panelWidth = size.x - this.base;
      }
      width = Math.min(size.x, this.base);
    }
    this.priorLevel = from;
    this.level = target;
    if (width === size.x) {
      finish(true);
      return;
    }
    this.written = {
      axis: 'x',
      viewport: window.innerWidth,
      native: size.x,
      target: width,
    };
    Byond.winset(Byond.windowId, { size: `${width}x${size.y}` });
  }

  /** previewGrowth is the Side Preview's width in CSS pixels, given while it is open */
  async setExpanded(
    expanded: boolean,
    kind: Expansion = 'editor',
    previewGrowth?: number,
    onLayoutSettled?: () => void,
  ) {
    this.wanted = previewGrowth ? PREVIEWING : expanded ? EDITING : GALLERY;
    this.wantedKind = kind;
    this.previewGrowth = previewGrowth;
    this.onLayoutSettled = onLayoutSettled;
    await this.apply(true);
  }

  dispose() {
    this.disposed = true;
    window.removeEventListener('resize', this.resized);
    window.clearTimeout(this.settling);
    this.written = undefined;
    this.finish?.(false);
  }
}
