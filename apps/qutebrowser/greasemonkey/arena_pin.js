// ==UserScript==
// @name         Arena Hardcore Switcher
// @namespace    http://tampermonkey.net/
// @version      3.2
// @description  Слушает Ctrl+G/Ctrl+P и переключает модели
// @match        *://*.arena.ai/*
// @exclude      *://*.arena.ai/c/*
// @run-at       document-idle
// ==/UserScript==

const DEFAULT_MODEL = "gemini-3.1-pro-preview";
const DEFAULT_FLASH_MODEL = "gemini-3.5-flash";

const MODEL_MAP = {
  pro: DEFAULT_MODEL,
  flash: DEFAULT_FLASH_MODEL,
};

(function () {
  "use strict";

  const urlParams = new URLSearchParams(window.location.search);

  let autoStartModel = DEFAULT_MODEL;

  if (urlParams.has("m")) {
    const requestedShortcode = urlParams.get("m").toLowerCase();
    autoStartModel = MODEL_MAP[requestedShortcode] || requestedShortcode;
    console.log(
      "[Switcher] URL параметр найден! Автозапуск настроен на:",
      autoStartModel,
    );
  }

  async function switchModel(modelName) {
    console.log("[Switcher] Начинаю поиск модели:", modelName);

    const buttons = Array.from(
      document.querySelectorAll('button[aria-haspopup="dialog"]'),
    );
    const triggerBtn = buttons.find((btn) =>
      btn.querySelector("span.truncate"),
    );

    if (!triggerBtn) {
      console.log("[Switcher] ОШИБКА: Главная кнопка меню не найдена.");
      return;
    }

    if (
      triggerBtn.textContent.toLowerCase().includes(modelName.toLowerCase())
    ) {
      console.log("[Switcher] Модель уже выбрана. Просто ставлю курсор.");
      if (textarea) textarea.focus();
      return;
    }

    triggerBtn.click();

    await new Promise((resolve) => setTimeout(resolve, 200));

    const dialog = document.querySelector('div[role="dialog"]');
    if (!dialog) {
      console.log("[Switcher] ОШИБКА: Диалог не появился.");
      return;
    }

    const options = Array.from(dialog.querySelectorAll("button"));

    const targetBtn = options.find((btn) =>
      btn.textContent.toLowerCase().includes(modelName.toLowerCase()),
    );

    if (targetBtn) {
      targetBtn.click();
      console.log("[Switcher] Успешно выбрано:", targetBtn.textContent);
    } else {
      document.dispatchEvent(new KeyboardEvent("keydown", { key: "Escape" }));
      console.log("[Switcher] ОШИБКА: Модель не найдена в списке:", modelName);
    }
  }

  document.addEventListener("keydown", function (event) {
    if (event.ctrlKey || event.metaKey) {
      if (event.code === "KeyG") {
        event.preventDefault();
        if (event.shiftKey) {
          switchModel(DEFAULT_FLASH_MODEL);
        } else {
          switchModel(DEFAULT_MODEL);
        }
      }
    }
  });

  const initTimer = setInterval(() => {
    if (window.location.pathname.startsWith("/c/")) {
      clearInterval(initTimer);
      return;
    }

    const buttons = Array.from(
      document.querySelectorAll('button[aria-haspopup="dialog"]'),
    );
    const triggerBtn = buttons.find((btn) =>
      btn.querySelector("span.truncate"),
    );

    clearInterval(initTimer);
    console.log("[Switcher] Сайт прогрузился! Запускаю авто-выбор...");
    triggerBtn.click();
    switchModel(autoStartModel);
  }, 200);
})();
