/** Screen pixels per layout pixel of an element measured as bounds, which tgui's scaling can make differ from 1 */
export const layoutScale = (element: HTMLElement, bounds: DOMRect) =>
  bounds.width / element.offsetWidth || 1;
