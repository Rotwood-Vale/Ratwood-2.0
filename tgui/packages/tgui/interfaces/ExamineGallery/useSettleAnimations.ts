import { type RefObject, useEffect } from 'react';

export const useSettleAnimations = (
  rootRef: RefObject<HTMLDivElement | null>,
) => {
  // A hidden or unfocused window can freeze an animation partway, so everything lands at once before that
  useEffect(() => {
    const settle = () => {
      for (const animation of rootRef.current?.getAnimations({
        subtree: true,
      }) ?? []) {
        if (animation.effect?.getTiming().iterations !== Infinity) {
          animation.finish();
        }
      }
    };
    window.addEventListener('blur', settle);
    window.addEventListener('focus', settle);
    document.addEventListener('visibilitychange', settle);
    return () => {
      window.removeEventListener('blur', settle);
      window.removeEventListener('focus', settle);
      document.removeEventListener('visibilitychange', settle);
    };
  }, []);
};
