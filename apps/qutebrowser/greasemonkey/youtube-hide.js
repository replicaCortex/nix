// ==UserScript==
// @name         YouTube - Только Поиск (Без рекомендаций)
// @namespace    http://tampermonkey.net/
// @version      1.2
// @description  Полностью убирает рекомендации на главной и в плеере под Polymer/ShadyDOM, оставляя только поиск.
// @author       User
// @match        https://www.youtube.com/*
// @grant        none
// @run-at       document-start
// ==/UserScript==

(function () {
  "use strict";

  // CSS-правила, которые мгновенно скрывают ненужные блоки
  const css = `
        ytd-browse[page-subtype="home"] {
            display: none !important;
        }

        ytd-ghost-grid-renderer,
        #home-page-skeleton {
            display: none !important;
        }

        #related,
        ytd-watch-next-secondary-results-renderer {
            display: none !important;
        }

        .html5-endscreen,
        .ytp-endscreen-content,
        .ytp-ce-element,
        .ytp-ce-covering-overlay,
        .ytp-ce-element-show {
            display: none !important;
        }
    `;

  // Функция мгновенного внедрения стилей в документ
  const injectStyles = () => {
    const style = document.createElement("style");
    style.textContent = css;
    (document.head || document.documentElement).appendChild(style);
  };

  // Проверяем готовность документа для внедрения
  if (document.head || document.documentElement) {
    injectStyles();
  } else {
    // Если скрипт сработал слишком рано, ждем появления первого элемента
    const observer = new MutationObserver(() => {
      if (document.head || document.documentElement) {
        injectStyles();
        observer.disconnect();
      }
    });
    observer.observe(document, { childList: true, subtree: true });
  }
})();
