import { useState } from 'react';

/** Copies text to the clipboard, through a hidden text area when the clipboard API refuses, and resolves whether it copied */
export const copyUrl = async (url: string) => {
  try {
    await navigator.clipboard.writeText(url);
    return true;
  } catch {
    const previousFocus = document.activeElement as HTMLElement | null;
    const field = document.createElement('textarea');
    field.value = url;
    field.style.position = 'fixed';
    field.style.opacity = '0';
    document.body.appendChild(field);
    field.select();
    try {
      return document.execCommand('copy');
    } catch {
      return false;
    } finally {
      field.remove();
      previousFocus?.focus();
    }
  }
};

/** A copy action and the status line it leaves, which tells the owner to copy by hand when copying fails */
export const useCopyUrl = () => {
  const [message, setMessage] = useState('');
  const copy = async (
    url: string,
    copiedMessage: string,
    onFail: () => void,
  ) => {
    const copied = await copyUrl(url);
    setMessage(
      copied ? copiedMessage : 'Select the URL and press Ctrl+C to copy.',
    );
    if (!copied) {
      onFail();
    }
  };
  return { message, copy, clear: () => setMessage('') };
};
