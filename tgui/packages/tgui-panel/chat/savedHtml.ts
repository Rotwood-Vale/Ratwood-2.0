// Only the item sprites explicitly marked by examine rendering are omitted.
// Keep live messages intact, including portraits and unrelated chat images.
export const withoutExamineIcons = (html: string): string => {
  if (!html.includes('data-examine-icon')) {
    return html;
  }
  const template = document.createElement('template');
  template.innerHTML = html;
  for (const icon of template.content.querySelectorAll(
    'img[data-examine-icon]',
  )) {
    icon.remove();
  }
  return template.innerHTML;
};

// Weak keys let pruned messages go away. Compare the HTML as messages can change.
const savedHtmlCache = new WeakMap<object, { source: string; saved: string }>();

export const getSavedMessageHtml = (message: { html?: string }) => {
  const source = message.html;
  if (typeof source !== 'string' || !source.includes('data-examine-icon')) {
    return source;
  }
  const cached = savedHtmlCache.get(message);
  if (cached?.source === source) {
    return cached.saved;
  }
  const saved = withoutExamineIcons(source);
  savedHtmlCache.set(message, { source, saved });
  return saved;
};
