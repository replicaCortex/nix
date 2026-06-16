// ==UserScript==
// @name         Arena.ai / LMSYS Arena Chat Exporter
// @name:zh-CN   Arena.ai / LMSYS Arena 聊天导出器
// @namespace    http://tampermonkey.net/
// @version      2.1
// @description  Export arena.ai, lmarena.ai, and legacy LMSYS Arena chats as JSON or TXT with list selection and ZIP packaging
// @description:zh-CN  导出 arena.ai、lmarena.ai 与旧版 LMSYS Arena 聊天记录，支持 JSON、TXT、列表勾选与 ZIP 打包
// @match        https://arena.ai/*
// @match        https://*.arena.ai/*
// @match        https://lmarena.ai/*
// @match        https://*.lmarena.ai/*
// @match        https://chat.lmsys.org/*
// @match        https://arena.lmsys.org/*
// @require      https://cdn.jsdelivr.net/npm/fflate@0.8.2/umd/index.js
// @run-at       document-idle
// @license      GPLv3
// @downloadURL https://update.greasyfork.org/scripts/492216/Arenaai%20%20LMSYS%20Arena%20Chat%20Exporter.user.js
// @updateURL https://update.greasyfork.org/scripts/492216/Arenaai%20%20LMSYS%20Arena%20Chat%20Exporter.meta.js
// ==/UserScript==

(function () {
  "use strict";

  const LOG_TAG = "[arena-chat-export]";
  const HISTORY_ENDPOINT = "/api/history/unified";
  const EVALUATION_ENDPOINT_PREFIX = "/api/evaluation/";
  const AGENT_PAGE_PREFIX = "/agent/";
  const DEFAULT_HISTORY_PAGE_SIZE = 20;
  const HISTORY_PAGE_GUARD = 200;

  const GUI_ROOT_ID = "arena-chat-export-gui-root";
  const GUI_DOCK_BUTTON_ID = "arena-chat-export-dock-btn";
  const GUI_PANEL_ID = "arena-chat-export-panel";
  const GUI_STATUS_ID = "arena-chat-export-status";

  const UUID_PATTERN =
    /([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/i;

  const I18N = {
    en: {
      unknown_error: "Unknown error",
      request_failed: "Request failed {status} {statusText}{suffix}",
      invalid_session_id: "Invalid conversation identifier.",
      unexpected_evaluation_shape: "The API did not return the expected conversation shape.",
      unknown_export_format: "Unknown export format: {format}",
      current_page_not_chat: "The current page is not a chat detail page.",
      zip_lib_missing: "ZIP library is not loaded, ZIP packaging is unavailable.",
      no_selected_items: "Select at least one conversation first.",
      batch_all_failed: "All selected exports failed, ZIP was not generated.",
      zip_generation_failed: "ZIP generation failed. Try fewer chats or switch export format.",
      untitled: "(untitled)",
      empty_message: "(empty)",
      dock_primary: "Export",
      dock_secondary: "Chat",
      dock_aria_open: "Open chat export panel",
      panel_title: "arena chat export",
      close_aria: "Close",
      section_current: "Current chat",
      button_download_json: "Download JSON",
      button_download_txt: "Download TXT",
      section_history: "Conversation list",
      button_fetch_history: "Fetch list",
      helper_history: "The list starts empty. After loading, multi-select exports will be packed into one ZIP.",
      button_select_all: "Select all",
      button_clear_selection: "Clear",
      selected_count: "{count} selected",
      history_empty: "No conversations loaded yet",
      button_export_selected_json: "Export selected JSON",
      button_export_selected_txt: "Export selected TXT",
      status_prefix: "Status: {message}",
      status_ready: "Ready. Download the current chat or load the list for batch export.",
      status_running: "{label}...",
      status_done: "{label} completed.",
      status_failed: "{label} failed: {message}",
      label_fetch_history: "Loading list",
      label_download_current: "Downloading current {format}",
      label_export_selected: "Exporting selected {format}",
      fetch_page_request: "Loading list... page {page}, loaded {count}",
      fetch_page_loaded: "Loaded page {page}. Conversations: {count}",
      fetch_complete: "Loaded {count} conversations.",
      fetch_guard_hit:
        "Loaded {count} conversations. The safety guard was hit; increase the guard if you still expect more.",
      current_download_done: "Current chat was downloaded as {format}.",
      zip_packing: "Packing {format} ZIP...",
      zip_packing_progress: "Packing {format} ZIP... {percent}%",
      batch_done_packaged_success_failed:
        "Batch export finished. ZIP ready. Success: {success}. Failed: {failed}.",
      batch_done_success_failed:
        "Batch export finished. Success: {success}. Failed: {failed}.",
      batch_done_packaged_success:
        "Batch export finished. ZIP ready. Success: {success}.",
      batch_done_success: "Batch export finished. Success: {success}.",
      selected_all_done: "All loaded conversations are selected.",
      cleared_selection_done: "Selection cleared.",
      gui_init_failed: "GUI initialization failed: missing required nodes.",
      readonly_ui_comment:
        "Only human-readable fields are shown in the list. Internal UUIDs stay hidden in the GUI.",
      switched_language: "Language updated. Reloading...",
      attach_summary_one: "{count} file attached",
      attach_summary_many: "{count} files attached",
      txt_title_fallback: "(untitled)",
    },
    "zh-CN": {
      unknown_error: "未知错误",
      request_failed: "请求失败 {status} {statusText}{suffix}",
      invalid_session_id: "会话标识无效。",
      unexpected_evaluation_shape: "接口返回不是预期的聊天详情结构。",
      unknown_export_format: "未知导出格式：{format}",
      current_page_not_chat: "当前页面不是聊天详情页，无法识别会话。",
      zip_lib_missing: "ZIP 打包库未加载，无法生成 ZIP。",
      no_selected_items: "请先勾选至少一条聊天记录。",
      batch_all_failed: "批量导出全部失败，未生成 ZIP。",
      zip_generation_failed: "ZIP 生成失败。请尝试减少勾选数量，或切换导出格式。",
      untitled: "(无标题)",
      empty_message: "(empty)",
      dock_primary: "导出",
      dock_secondary: "聊天",
      dock_aria_open: "打开聊天导出面板",
      panel_title: "arena 聊天导出",
      close_aria: "关闭",
      section_current: "当前聊天",
      button_download_json: "下载 JSON",
      button_download_txt: "下载 TXT",
      section_history: "聊天列表",
      button_fetch_history: "抓取列表",
      helper_history: "列表初始为空，抓取后可勾选导出；多选时会自动打包成一个 ZIP。",
      button_select_all: "全选",
      button_clear_selection: "清空选择",
      selected_count: "已选 {count} 条",
      history_empty: "尚未抓取聊天列表",
      button_export_selected_json: "导出勾选 JSON",
      button_export_selected_txt: "导出勾选 TXT",
      status_prefix: "状态：{message}",
      status_ready: "就绪。可下载当前聊天，或先抓取列表后批量导出。",
      status_running: "{label}执行中...",
      status_done: "{label}完成。",
      status_failed: "{label}失败：{message}",
      label_fetch_history: "抓取列表",
      label_download_current: "下载当前{format}",
      label_export_selected: "导出勾选{format}",
      fetch_page_request: "正在抓取第 {page} 页，当前已拿到 {count} 条",
      fetch_page_loaded: "已抓取到第 {page} 页，当前共 {count} 条",
      fetch_complete: "抓取完成，共 {count} 条。",
      fetch_guard_hit: "抓取完成，当前已拿到 {count} 条；若你仍怀疑没抓全，再把安全上限继续调大。",
      current_download_done: "当前聊天已下载为 {format}。",
      zip_packing: "正在打包 {format} ZIP...",
      zip_packing_progress: "正在打包 {format} ZIP... {percent}%",
      batch_done_packaged_success_failed:
        "批量导出完成：已打包 ZIP，成功 {success} 条，失败 {failed} 条。",
      batch_done_success_failed: "批量导出完成：成功 {success} 条，失败 {failed} 条。",
      batch_done_packaged_success: "批量导出完成：已打包 ZIP，共 {success} 条。",
      batch_done_success: "批量导出完成：成功 {success} 条。",
      selected_all_done: "已全选当前列表。",
      cleared_selection_done: "已清空选择。",
      gui_init_failed: "GUI 初始化失败：节点缺失。",
      readonly_ui_comment: "列表只展示可读信息，内部 UUID 不直接显示在 GUI 上。",
      switched_language: "语言已切换，正在刷新...",
      attach_summary_one: "附件 {count} 个",
      attach_summary_many: "附件 {count} 个",
      txt_title_fallback: "(untitled)",
    },
  };

  function normalizeLocale(locale) {
    const value = String(locale || "").trim().toLowerCase();
    if (!value) {
      return "";
    }
    if (value.startsWith("zh")) {
      return "zh-CN";
    }
    return "en";
  }

  function getInitialLocale() {
    const browserLocale =
      navigator.language || (Array.isArray(navigator.languages) ? navigator.languages[0] : "");
    return normalizeLocale(browserLocale) || "en";
  }

  let currentLocale = getInitialLocale();

  function t(key, vars) {
    const table = I18N[currentLocale] || I18N.en;
    const fallback = I18N.en;
    let text = table[key] || fallback[key] || key;
    if (!vars) {
      return text;
    }
    return text.replace(/\{([a-zA-Z0-9_]+)\}/g, (_match, name) => {
      const value = vars[name];
      return value == null ? "" : String(value);
    });
  }

  function log(...args) {
    console.log(LOG_TAG, ...args);
  }

  function warn(...args) {
    console.warn(LOG_TAG, ...args);
  }

  function toErrorMessage(error) {
    if (!error) {
      return t("unknown_error");
    }
    if (typeof error === "string") {
      return error;
    }
    if (error instanceof Error) {
      return error.message || String(error);
    }
    return String(error);
  }

  function extractConversationId(text) {
    const source = String(text || "");
    const match = source.match(UUID_PATTERN);
    return match ? match[1].toLowerCase() : null;
  }

  function getConversationIdFromCurrentUrl() {
    const pathname = String(location.pathname || "");
    const match = pathname.match(
      /\/(?:[a-z]{2}(?:-[A-Z]{2})?\/)?c\/([0-9a-f-]{36})(?:\/|$)/i
    );
    return match ? match[1].toLowerCase() : null;
  }

  function getAgentIdFromCurrentUrl() {
    const pathname = String(location.pathname || "");
    const match = pathname.match(
      /\/(?:[a-z]{2}(?:-[A-Z]{2})?\/)?agent\/([0-9a-f-]{36})(?:\/|$)/i
    );
    return match ? match[1].toLowerCase() : null;
  }

  function sanitizeFileNamePart(text, maxLength) {
    const raw = String(text || "")
      .replace(/[<>:"/\\|?*\u0000-\u001f]/g, "_")
      .replace(/\s+/g, " ")
      .trim();
    if (!raw) {
      return "untitled";
    }
    const compact = raw.replace(/[. ]+$/g, "");
    return compact.slice(0, maxLength || 60) || "untitled";
  }

  function truncateText(text, maxLength) {
    const source = String(text || "");
    if (source.length <= maxLength) {
      return source;
    }
    return `${source.slice(0, Math.max(0, maxLength - 1))}...`;
  }

  function formatUiTime(text) {
    const value = String(text || "").trim();
    if (!value) {
      return "-";
    }
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return value;
    }
    return date.toLocaleString();
  }

  function pad2(value) {
    return String(value).padStart(2, "0");
  }

  function formatTextTime(text) {
    const value = String(text || "").trim();
    if (!value) {
      return "-";
    }
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return value;
    }
    return [
      date.getFullYear(),
      pad2(date.getMonth() + 1),
      pad2(date.getDate()),
    ].join("-") + " " + [pad2(date.getHours()), pad2(date.getMinutes()), pad2(date.getSeconds())].join(":");
  }

  function wait(ms) {
    return new Promise((resolve) => {
      window.setTimeout(resolve, ms);
    });
  }

  async function safeReadText(response) {
    try {
      return await response.text();
    } catch (_error) {
      return "";
    }
  }

  async function fetchJson(url) {
    // HAR 已验证请求基于同域会话 Cookie，这里固定 credentials=include。
    const response = await fetch(url, {
      method: "GET",
      credentials: "include",
      headers: {
        Accept: "application/json, text/plain, */*",
      },
    });
    if (!response.ok) {
      const responseText = truncateText(await safeReadText(response), 300);
      const suffix = responseText ? ` - ${responseText}` : "";
      throw new Error(
        t("request_failed", {
          status: response.status,
          statusText: response.statusText,
          suffix,
        })
      );
    }
    return await response.json();
  }

  async function fetchEvaluationById(conversationId) {
    const id = extractConversationId(conversationId);
    if (!id) {
      throw new Error(t("invalid_session_id"));
    }
    return await fetchJson(`${location.origin}${EVALUATION_ENDPOINT_PREFIX}${id}`);
  }

  async function fetchHistoryList(pageGuard, includeArchived, hooks) {
    const merged = [];
    let cursor = null;
    let currentPage = 0;
    while (currentPage < pageGuard) {
      const nextPageNumber = currentPage + 1;
      hooks?.onPageRequest?.({
        page: nextPageNumber,
        totalCount: merged.length,
      });
      const params = new URLSearchParams();
      params.set("limit", String(DEFAULT_HISTORY_PAGE_SIZE));
      params.set("includeArchived", includeArchived ? "true" : "false");
      if (cursor) {
        params.set("cursor", cursor);
      }
      const requestUrl = `${location.origin}${HISTORY_ENDPOINT}?${params.toString()}`;
      const payload = await fetchJson(requestUrl);
      const batch = Array.isArray(payload?.entries) ? payload.entries : [];
      merged.push(...batch);

      const hasMore = Boolean(payload?.pagination?.hasMore);
      const nextCursor =
        typeof payload?.pagination?.cursor === "string"
          ? payload.pagination.cursor
          : null;
      currentPage += 1;
      hooks?.onPageLoaded?.({
        page: currentPage,
        batchCount: batch.length,
        totalCount: merged.length,
        hasMore,
      });
      if (!hasMore || !nextCursor) {
        break;
      }
      cursor = nextCursor;
    }
    return merged;
  }

  function decodeNextFlightTextFromHtml(html) {
    const parts = [];
    const pattern = /self\.__next_f\.push\(\[1,"((?:\\.|[^"\\])*)"\]\)<\/script>/g;
    let match;
    while ((match = pattern.exec(String(html || "")))) {
      try {
        parts.push(JSON.parse(`"${match[1]}"`));
      } catch (error) {
        warn("failed to decode Next.js flight chunk", error);
      }
    }
    return parts.join("");
  }

  function readUtf8ByteLengthSegment(text, startIndex, byteLength) {
    const encoder = new TextEncoder();
    let index = startIndex;
    let bytes = 0;
    while (index < text.length && bytes < byteLength) {
      const codePoint = text.codePointAt(index);
      const char = String.fromCodePoint(codePoint);
      const charBytes = encoder.encode(char).length;
      if (bytes + charBytes > byteLength) {
        break;
      }
      bytes += charBytes;
      index += char.length;
    }
    return {
      text: text.slice(startIndex, index),
      endIndex: index,
    };
  }

  function extractNextFlightTextRecords(flightText) {
    const records = {};
    const pattern = /([0-9a-f]+):T([0-9a-f]+),/gi;
    let match;
    while ((match = pattern.exec(flightText))) {
      if (!match) {
        break;
      }
      const id = match[1].toLowerCase();
      const byteLength = parseInt(match[2], 16);
      const startIndex = pattern.lastIndex;
      const segment = readUtf8ByteLengthSegment(flightText, startIndex, byteLength);
      records[id] = segment.text;
      pattern.lastIndex = segment.endIndex;
    }
    return records;
  }

  function extractJsonObjectAt(text, startIndex) {
    let depth = 0;
    let inString = false;
    let escaping = false;
    for (let index = startIndex; index < text.length; index += 1) {
      const char = text[index];
      if (inString) {
        if (escaping) {
          escaping = false;
        } else if (char === "\\") {
          escaping = true;
        } else if (char === '"') {
          inString = false;
        }
        continue;
      }
      if (char === '"') {
        inString = true;
        continue;
      }
      if (char === "{") {
        depth += 1;
      } else if (char === "}") {
        depth -= 1;
        if (depth === 0) {
          return text.slice(startIndex, index + 1);
        }
      }
    }
    return null;
  }

  function resolveNextFlightTextReferences(value, textRecords) {
    if (typeof value === "string") {
      const match = value.match(/^\$([0-9a-f]+)$/i);
      if (match) {
        const replacement = textRecords[match[1].toLowerCase()];
        if (typeof replacement === "string") {
          return replacement;
        }
      }
      return value;
    }
    if (Array.isArray(value)) {
      return value.map((item) => resolveNextFlightTextReferences(item, textRecords));
    }
    if (value && typeof value === "object") {
      const next = {};
      for (const [key, item] of Object.entries(value)) {
        next[key] = resolveNextFlightTextReferences(item, textRecords);
      }
      return next;
    }
    return value;
  }

  function extractAgentPayloadObjectText(flightText) {
    let searchIndex = 0;
    while (searchIndex < flightText.length) {
      const objectStartIndex = flightText.indexOf('{"messages":[', searchIndex);
      if (objectStartIndex < 0) {
        return null;
      }
      const objectText = extractJsonObjectAt(flightText, objectStartIndex);
      if (!objectText) {
        return null;
      }
      try {
        const candidate = JSON.parse(objectText);
        if (
          Array.isArray(candidate?.messages) &&
          candidate.messages.some((message) => Array.isArray(message?.parts) && message?.role)
        ) {
          return objectText;
        }
      } catch (_error) {
        // Keep scanning; a fetched web page embedded in the Flight stream may contain unrelated JSON.
      }
      searchIndex = objectStartIndex + 1;
    }
    return null;
  }

  function getTextFromAgentParts(parts) {
    return (Array.isArray(parts) ? parts : [])
      .filter((part) => part && part.type === "text" && typeof part.text === "string")
      .map((part) => part.text)
      .filter(Boolean)
      .join("\n\n");
  }

  function buildAgentTitle(agent) {
    const explicitTitle = String(agent?.title || agent?.session?.title || "").trim();
    if (explicitTitle) {
      return explicitTitle;
    }
    const firstUser = (Array.isArray(agent?.messages) ? agent.messages : []).find(
      (message) => String(message?.role || "").toLowerCase() === "user"
    );
    return truncateText(getTextFromAgentParts(firstUser?.parts) || "agent chat", 80);
  }

  function sanitizeAgentForExport(agent) {
    if (!agent || typeof agent !== "object") {
      return agent;
    }
    const next = JSON.parse(JSON.stringify(agent));
    if (next.session && typeof next.session === "object" && next.session.publicAccessToken) {
      delete next.session.publicAccessToken;
      next.session.publicAccessTokenRedacted = true;
    }
    return next;
  }

  async function fetchAgentById(agentId, metadata) {
    const id = extractConversationId(agentId);
    if (!id) {
      throw new Error(t("invalid_session_id"));
    }
    const response = await fetch(`${location.origin}${AGENT_PAGE_PREFIX}${id}`, {
      method: "GET",
      credentials: "include",
      headers: {
        Accept: "text/html,application/xhtml+xml",
      },
    });
    if (!response.ok) {
      const responseText = truncateText(await safeReadText(response), 300);
      const suffix = responseText ? ` - ${responseText}` : "";
      throw new Error(
        t("request_failed", {
          status: response.status,
          statusText: response.statusText,
          suffix,
        })
      );
    }
    const html = await response.text();
    const flightText = decodeNextFlightTextFromHtml(html);
    const objectText = extractAgentPayloadObjectText(flightText);
    if (!objectText) {
      throw new Error(t("unexpected_evaluation_shape"));
    }
    const parsed = JSON.parse(objectText);
    const resolved = resolveNextFlightTextReferences(parsed, extractNextFlightTextRecords(flightText));
    const agent = {
      id,
      type: "agentic",
      title: String(metadata?.title || "").trim() || undefined,
      createdAt: metadata?.createdAt || "",
      updatedAt: metadata?.updatedAt || "",
      pageUrl: `${location.origin}${AGENT_PAGE_PREFIX}${id}`,
      ...resolved,
    };
    agent.title = buildAgentTitle(agent);
    return agent;
  }

  function normalizeContent(content) {
    if (content == null) {
      return "";
    }
    if (typeof content === "string") {
      return content;
    }
    if (Array.isArray(content)) {
      return content
        .map((part) => {
          if (typeof part === "string") {
            return part;
          }
          if (part && typeof part === "object") {
            if (typeof part.text === "string") {
              return part.text;
            }
            if (part.type === "image_url") {
              return `[image] ${part?.image_url?.url || ""}`;
            }
            return JSON.stringify(part, null, 2);
          }
          return String(part);
        })
        .join("\n");
    }
    if (typeof content === "object") {
      if (typeof content.text === "string") {
        return content.text;
      }
      if (Array.isArray(content.parts)) {
        return normalizeContent(content.parts);
      }
      return JSON.stringify(content, null, 2);
    }
    return String(content);
  }

  function formatSpeakerName(message, evaluation) {
    const role = String(message?.role || "").toLowerCase();
    if (role === "user") {
      return "User";
    }
    if (role === "assistant") {
      const position = String(message?.participantPosition || "").trim().toUpperCase();
      if (position === "A" || position === "B") {
        return `AI ${position}`;
      }
      if (evaluation?.mode === "battle") {
        return "AI";
      }
      return "AI";
    }
    if (role === "system") {
      return "System";
    }
    return role || "Unknown";
  }

  function formatAttachmentSummary(message) {
    const attachments = Array.isArray(message?.experimental_attachments)
      ? message.experimental_attachments
      : [];
    if (!attachments.length) {
      return "";
    }
    return `${attachments.length} file${attachments.length > 1 ? "s" : ""} attached`;
  }

  function getMessageParentKey(message) {
    const parentIds = Array.isArray(message?.parentMessageIds) ? message.parentMessageIds : [];
    return parentIds.join("|");
  }

  function getAssistantPositionRank(message) {
    const position = String(message?.participantPosition || "").trim().toUpperCase();
    if (position === "A") {
      return 0;
    }
    if (position === "B") {
      return 1;
    }
    return 9;
  }

  function getReadableTextMessages(messages) {
    const source = Array.isArray(messages) ? messages : [];
    const ordered = [];

    // battle 模式里同一轮常会出现两个相邻 assistant 响应；这里只对这类并列响应做 A -> B 重排，
    // 其余消息保持接口原始顺序，避免误伤多轮对话或其他模式。
    for (let index = 0; index < source.length; index += 1) {
      const current = source[index];
      const currentRole = String(current?.role || "").toLowerCase();
      if (currentRole !== "assistant") {
        ordered.push(current);
        continue;
      }

      const chunk = [current];
      const parentKey = getMessageParentKey(current);
      while (index + 1 < source.length) {
        const next = source[index + 1];
        const nextRole = String(next?.role || "").toLowerCase();
        if (nextRole !== "assistant" || getMessageParentKey(next) !== parentKey) {
          break;
        }
        chunk.push(next);
        index += 1;
      }

      chunk.sort((left, right) => {
        const rankDiff = getAssistantPositionRank(left) - getAssistantPositionRank(right);
        if (rankDiff !== 0) {
          return rankDiff;
        }
        return 0;
      });

      ordered.push(...chunk);
    }

    return ordered;
  }

  function formatEvaluationAsText(evaluation) {
    const messages = getReadableTextMessages(evaluation?.messages);
    const lines = [];
    lines.push("============================================================");
    lines.push("arena.ai chat export");
    lines.push("============================================================");
    lines.push(`Title    : ${evaluation?.title || "(untitled)"}`);
    lines.push(`Mode     : ${evaluation?.mode || "unknown"}`);
    lines.push(`Started  : ${formatTextTime(evaluation?.createdAt)}`);
    lines.push(`Updated  : ${formatTextTime(evaluation?.updatedAt)}`);
    lines.push(`Messages : ${messages.length}`);
    lines.push(`URL      : ${location.origin}/c/${evaluation?.id || ""}`);
    lines.push("");

    messages.forEach((message, index) => {
      const speaker = formatSpeakerName(message, evaluation);
      const time = formatTextTime(message?.createdAt);
      const content = normalizeContent(message?.content) || t("empty_message");
      const attachmentSummary = formatAttachmentSummary(message);

      lines.push("------------------------------------------------------------");
      lines.push(`Message  : ${index + 1}`);
      lines.push(`Speaker  : ${speaker}`);
      lines.push(`Time     : ${time}`);
      if (attachmentSummary) {
        lines.push(`Attach   : ${attachmentSummary}`);
      }
      lines.push("------------------------------------------------------------");
      lines.push(content);
      if (index !== messages.length - 1) {
        lines.push("");
      }
    });

    return `${lines.join("\n")}\n`;
  }

  function isAgentExportObject(record) {
    return record?.type === "agentic" || (Array.isArray(record?.messages) && record.messages.some((message) => Array.isArray(message?.parts)));
  }

  function formatAgentPartAsText(part) {
    if (!part || typeof part !== "object") {
      return "";
    }
    if (part.type === "text" && typeof part.text === "string") {
      return part.text;
    }
    if (part.type === "reasoning" && typeof part.text === "string" && part.text.trim()) {
      return `[reasoning]\n${part.text}`;
    }
    if (String(part.type || "").startsWith("tool-")) {
      const toolName = String(part.type || "tool").replace(/^tool-/, "");
      const lines = [`[tool: ${toolName}]`];
      if (part.input && typeof part.input === "object") {
        if (part.input.query) {
          lines.push(`query: ${part.input.query}`);
        } else if (part.input.url) {
          lines.push(`url: ${part.input.url}`);
        }
      }
      if (part.output && typeof part.output === "object") {
        if (part.output.status) {
          lines.push(`status: ${part.output.status}`);
        }
        if (Array.isArray(part.output.results)) {
          part.output.results.slice(0, 8).forEach((result, index) => {
            const title = result?.title || result?.url || `result ${index + 1}`;
            const url = result?.url ? ` - ${result.url}` : "";
            lines.push(`${index + 1}. ${title}${url}`);
          });
        } else if (part.output.title || part.output.url) {
          lines.push(`${part.output.title || part.output.url}${part.output.url ? ` - ${part.output.url}` : ""}`);
        } else if (part.output.error) {
          lines.push(`error: ${part.output.error}`);
        }
      }
      return lines.join("\n");
    }
    return "";
  }

  function formatAgentAsText(agent) {
    const messages = Array.isArray(agent?.messages) ? agent.messages : [];
    const lines = [];
    lines.push("============================================================");
    lines.push("arena.ai agent chat export");
    lines.push("============================================================");
    lines.push(`Title    : ${agent?.title || "(untitled)"}`);
    lines.push(`Type     : agentic`);
    lines.push(`Started  : ${formatTextTime(agent?.createdAt)}`);
    lines.push(`Updated  : ${formatTextTime(agent?.updatedAt)}`);
    lines.push(`Messages : ${messages.length}`);
    lines.push(`URL      : ${agent?.pageUrl || `${location.origin}${AGENT_PAGE_PREFIX}${agent?.id || ""}`}`);
    lines.push("");

    messages.forEach((message, index) => {
      const role = String(message?.role || "unknown");
      const parts = Array.isArray(message?.parts) ? message.parts : [];
      const content = parts.map(formatAgentPartAsText).filter(Boolean).join("\n\n") || t("empty_message");
      lines.push("------------------------------------------------------------");
      lines.push(`Message  : ${index + 1}`);
      lines.push(`Speaker  : ${role}`);
      lines.push("------------------------------------------------------------");
      lines.push(content);
      if (index !== messages.length - 1) {
        lines.push("");
      }
    });

    return `${lines.join("\n")}\n`;
  }

  function buildJsonExportObject(record) {
    if (isAgentExportObject(record)) {
      const agent = sanitizeAgentForExport(record);
      return {
        exportedAt: new Date().toISOString(),
        source: location.origin,
        recordType: "agentic",
        conversationUrl: agent?.pageUrl || `${location.origin}${AGENT_PAGE_PREFIX}${agent?.id || ""}`,
        agent,
      };
    }
    return {
      exportedAt: new Date().toISOString(),
      source: location.origin,
      recordType: "evaluation",
      conversationUrl: `${location.origin}/c/${record?.id || ""}`,
      evaluation: record,
    };
  }

  function buildFileName(record, extension) {
    // UI 不直接展示 UUID，文件名也只保留标题与时间戳。
    const title = sanitizeFileNamePart(record?.title || "chat", 56);
    const time = new Date().toISOString().replace(/[:.]/g, "-");
    const prefix = isAgentExportObject(record) ? "arena-agent" : "arena-chat";
    return `${prefix}-${title}-${time}.${extension}`;
  }

  function downloadBlob(fileName, mimeType, content) {
    const blob = content instanceof Blob ? content : new Blob([content], { type: mimeType });
    const objectUrl = URL.createObjectURL(blob);
    const anchor = document.createElement("a");
    anchor.href = objectUrl;
    anchor.download = fileName;
    document.body.appendChild(anchor);
    anchor.click();
    anchor.remove();
    window.setTimeout(() => URL.revokeObjectURL(objectUrl), 1000);
  }

  function buildZipFileName(format) {
    const time = new Date().toISOString().replace(/[:.]/g, "-");
    return `arena-chat-export-${format === "txt" ? "txt" : "json"}-${time}.zip`;
  }

  function getExportPayload(record, format) {
    if (!record || typeof record !== "object" || !record.id) {
      throw new Error(t("unexpected_evaluation_shape"));
    }
    if (format === "json") {
      const fileName = buildFileName(record, "json");
      const jsonText = `${JSON.stringify(buildJsonExportObject(record), null, 2)}\n`;
      return {
        fileName,
        mimeType: "application/json;charset=utf-8",
        textContent: jsonText,
      };
    }
    if (format === "txt") {
      const fileName = buildFileName(record, "txt");
      return {
        fileName,
        mimeType: "text/plain;charset=utf-8",
        textContent: isAgentExportObject(record) ? formatAgentAsText(record) : formatEvaluationAsText(record),
      };
    }
    throw new Error(t("unknown_export_format", { format }));
  }

  async function exportConversation(conversationId, format) {
    const evaluation = await fetchEvaluationById(conversationId);
    const payload = getExportPayload(evaluation, format);
    downloadBlob(payload.fileName, payload.mimeType, payload.textContent);
    return payload.fileName;
  }

  async function fetchExportRecord(item) {
    const id = extractConversationId(item?.id || item);
    if (!id) {
      throw new Error(t("invalid_session_id"));
    }
    const type = String(item?.type || "evaluation");
    if (type === "agentic") {
      return await fetchAgentById(id, item);
    }
    return await fetchEvaluationById(id);
  }

  async function exportHistoryItem(item, format) {
    const record = await fetchExportRecord(item);
    const payload = getExportPayload(record, format);
    downloadBlob(payload.fileName, payload.mimeType, payload.textContent);
    return payload.fileName;
  }

  async function exportCurrentConversation(format) {
    const evaluationId = getConversationIdFromCurrentUrl();
    if (evaluationId) {
      return await exportConversation(evaluationId, format);
    }
    const agentId = getAgentIdFromCurrentUrl();
    if (agentId) {
      return await exportHistoryItem({ id: agentId, type: "agentic" }, format);
    }
    if (!evaluationId && !agentId) {
      throw new Error(t("current_page_not_chat"));
    }
  }

  function getZipLib() {
    if (typeof fflate === "object" && fflate) {
      return fflate;
    }
    if (typeof window.fflate === "object" && window.fflate) {
      return window.fflate;
    }
    throw new Error(t("zip_lib_missing"));
  }

  function getHistoryItemKey(item) {
    const id = extractConversationId(item?.id || item);
    const type = String(item?.type || "evaluation");
    return id ? `${type}:${id}` : "";
  }

  function normalizeExportItems(items) {
    const normalized = [];
    const dedupe = new Set();
    for (const value of items || []) {
      const id = extractConversationId(value?.id || value);
      if (!id) {
        continue;
      }
      const type = String(value?.type || "evaluation");
      const key = `${type}:${id}`;
      if (dedupe.has(key)) {
        continue;
      }
      dedupe.add(key);
      normalized.push({
        ...(value && typeof value === "object" ? value : {}),
        id,
        type,
      });
    }
    return normalized;
  }

  async function exportBatchConversations(conversationItems, format, hooks) {
    const items = normalizeExportItems(conversationItems);
    if (!items.length) {
      throw new Error(t("no_selected_items"));
    }

    if (items.length === 1) {
      const fileName = await exportHistoryItem(items[0], format);
      return { total: 1, successCount: 1, failedCount: 0, packaged: false, fileName };
    }

    // 多选时改为一次性打包 ZIP，避免浏览器连续触发多个下载弹窗。
    const zipLib = getZipLib();
    const usedNames = new Set();
    const archiveEntries = {};
    let successCount = 0;
    let failedCount = 0;
    for (let i = 0; i < items.length; i += 1) {
      hooks?.onProgress?.({ index: i + 1, total: items.length, successCount, failedCount });
      try {
        const record = await fetchExportRecord(items[i]);
        const payload = getExportPayload(record, format);
        let nextName = payload.fileName;
        if (usedNames.has(nextName)) {
          const dotIndex = nextName.lastIndexOf(".");
          const baseName = dotIndex > 0 ? nextName.slice(0, dotIndex) : nextName;
          const extension = dotIndex > 0 ? nextName.slice(dotIndex) : "";
          let suffix = 2;
          while (usedNames.has(`${baseName}-${suffix}${extension}`)) {
            suffix += 1;
          }
          nextName = `${baseName}-${suffix}${extension}`;
        }
        usedNames.add(nextName);
        archiveEntries[nextName] = zipLib.strToU8(payload.textContent);
        successCount += 1;
      } catch (error) {
        failedCount += 1;
        hooks?.onItemError?.({ index: i + 1, total: items.length, error });
      }
      await wait(160);
    }

    if (!successCount) {
      throw new Error(t("batch_all_failed"));
    }

    hooks?.onZipProgressStart?.({ total: items.length, successCount, failedCount });
    let zipBytes;
    try {
      // fflate.zipSync is fast enough for these text exports and avoids the JSZip hang seen in the browser.
      hooks?.onZipProgress?.({ percent: 15 });
      zipBytes = zipLib.zipSync(archiveEntries, { level: 0 });
      hooks?.onZipProgress?.({ percent: 100 });
    } catch (error) {
      warn("zip generation failed", error);
      throw new Error(t("zip_generation_failed"));
    }
    const zipFileName = buildZipFileName(format);
    downloadBlob(zipFileName, "application/zip", zipBytes);
    return {
      total: items.length,
      successCount,
      failedCount,
      packaged: true,
      fileName: zipFileName,
    };
  }

  function installGui() {
    const mount = () => {
      if (!document.body || document.getElementById(GUI_ROOT_ID)) {
        return;
      }

      const style = document.createElement("style");
      style.id = `${GUI_ROOT_ID}-style`;
      style.textContent = `
        #${GUI_ROOT_ID}{
          --ace-font-sans: var(--font-basel-grotesk), var(--font-inter), ui-sans-serif, system-ui, sans-serif;
          --ace-surface: hsl(var(--surface-secondary, 0 0% 100%));
          --ace-surface-soft: hsl(var(--surface-tertiary, 33 31% 94%));
          --ace-surface-raised: hsl(var(--surface-raised, 33 28% 92%));
          --ace-surface-raised-alt: hsl(var(--surface-raised-alt, 33 20% 87%));
          --ace-surface-floating: hsl(var(--surface-floating, 33 60% 96%));
          --ace-text: hsl(var(--text-primary, 24 6% 17%));
          --ace-text-secondary: hsl(var(--text-secondary, 30 7% 24%));
          --ace-text-muted: hsl(var(--text-muted, 37 5% 52%));
          --ace-border: hsl(var(--border-medium, 30 9% 87%));
          --ace-border-faint: hsl(var(--border-faint, 30 5% 93%));
          --ace-primary: hsl(var(--interactive-cta, 60 3% 14%));
          --ace-primary-hover: hsl(var(--interactive-cta-hover, 24 6% 23%));
          --ace-primary-text: hsl(var(--interactive-on-cta, 36 45% 98%));
          --ace-link: hsl(var(--interactive-link, 208 77% 52%));
          --ace-positive: hsl(var(--interactive-positive, 125 49% 43%));
          --ace-negative: hsl(var(--interactive-negative, 2 63% 54%));
          --ace-radius: calc(var(--radius, 0.75rem) + 0.2rem);
          --ace-glass: hsl(var(--background, 36 45% 98%) / .66);
          --ace-glass-strong: hsl(var(--background, 36 45% 98%) / .82);
          --ace-glass-soft: hsl(var(--background, 36 45% 98%) / .52);
          --ace-glass-hover: hsl(var(--foreground, 24 6% 17%) / .08);
          --ace-glass-border: hsl(var(--foreground, 24 6% 17%) / .12);
          --ace-glass-border-strong: hsl(var(--foreground, 24 6% 17%) / .18);
          --ace-shadow: 0 18px 48px hsl(var(--foreground, 24 6% 17%) / .12);
          --ace-blur: blur(22px) saturate(135%);
        }
        #${GUI_DOCK_BUTTON_ID}{
          position:fixed;right:-34px;top:42vh;width:84px;height:118px;border:1px solid var(--ace-border);border-right:none;border-radius:var(--ace-radius) 0 0 var(--ace-radius);
          background:linear-gradient(180deg,var(--ace-glass-strong),var(--ace-glass));
          color:var(--ace-text);
          z-index:2147483000;opacity:.72;cursor:pointer;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:6px;
          font-family:var(--ace-font-sans);box-shadow:0 10px 30px hsl(var(--foreground, 24 6% 17%) / .12);transition:right .2s,opacity .2s,transform .2s;
          backdrop-filter:var(--ace-blur);-webkit-backdrop-filter:var(--ace-blur);border-color:var(--ace-glass-border-strong)
        }
        #${GUI_DOCK_BUTTON_ID}[data-open="true"],#${GUI_DOCK_BUTTON_ID}:hover{right:0;opacity:.98}
        #${GUI_DOCK_BUTTON_ID} .t1{font-size:13px;font-weight:700}
        #${GUI_DOCK_BUTTON_ID} .t2{font-size:11px;opacity:.78}
        #${GUI_PANEL_ID}{
          position:fixed;right:16px;top:70px;width:min(94vw,410px);max-height:min(84vh,800px);z-index:2147483001;
          background:
            linear-gradient(180deg,hsl(var(--background, 36 45% 98%) / .80),hsl(var(--background, 36 45% 98%) / .62));
          border:1px solid var(--ace-glass-border-strong);border-radius:calc(var(--ace-radius) + 2px);color:var(--ace-text);
          box-shadow:var(--ace-shadow);transform:translateX(16px) scale(.985);opacity:0;pointer-events:none;
          transition:transform .2s,opacity .2s;font-family:var(--ace-font-sans);overflow:hidden;
          backdrop-filter:var(--ace-blur);-webkit-backdrop-filter:var(--ace-blur)
        }
        #${GUI_PANEL_ID}[data-open="true"]{transform:translateX(0) scale(1);opacity:1;pointer-events:auto}
        #${GUI_PANEL_ID} .head{
          display:flex;justify-content:space-between;gap:8px;padding:12px 12px 8px;
          border-bottom:1px solid var(--ace-glass-border);
          background:linear-gradient(180deg,hsl(var(--background, 36 45% 98%) / .36),transparent)
        }
        #${GUI_PANEL_ID} .title{font-size:15px;font-weight:700;color:var(--ace-text)}
        #${GUI_PANEL_ID} .close{
          width:26px;height:26px;border:1px solid var(--ace-glass-border);border-radius:calc(var(--ace-radius) - 4px);
          background:var(--ace-glass-soft);color:var(--ace-text-secondary);cursor:pointer;font-size:17px;
          backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px)
        }
        #${GUI_PANEL_ID} .close:hover{background:var(--ace-glass-hover)}
        #${GUI_PANEL_ID} .body{padding:10px 12px 12px;display:flex;flex-direction:column;gap:10px;max-height:calc(min(84vh,800px) - 58px);overflow-y:auto}
        #${GUI_PANEL_ID} .sec{
          border:1px solid var(--ace-glass-border);border-radius:var(--ace-radius);background:var(--ace-glass-soft);
          padding:9px;display:flex;flex-direction:column;gap:8px;
          backdrop-filter:blur(10px);-webkit-backdrop-filter:blur(10px)
        }
        #${GUI_PANEL_ID} .sec-h{display:flex;justify-content:space-between;align-items:center;gap:8px}
        #${GUI_PANEL_ID} .sec-t{font-size:13px;font-weight:700;color:var(--ace-text)}
        #${GUI_PANEL_ID} .helper{font-size:12px;color:var(--ace-text-muted)}
        #${GUI_PANEL_ID} .row2{display:grid;grid-template-columns:1fr 1fr;gap:8px}
        #${GUI_PANEL_ID} .btn{
          border:1px solid var(--ace-glass-border);background:var(--ace-glass);color:var(--ace-text);border-radius:calc(var(--ace-radius) - 2px);
          padding:8px 10px;cursor:pointer;font-size:12px;line-height:1.2;white-space:nowrap;
          backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px)
        }
        #${GUI_PANEL_ID} .btn:hover{background:var(--ace-glass-hover);border-color:var(--ace-glass-border-strong)}
        #${GUI_PANEL_ID} .btn.em{
          background:hsl(var(--foreground, 24 6% 17%) / .10);border-color:var(--ace-glass-border-strong);color:var(--ace-text);font-weight:700
        }
        #${GUI_PANEL_ID} .btn.em:hover{background:hsl(var(--foreground, 24 6% 17%) / .16);border-color:hsl(var(--foreground, 24 6% 17%) / .24)}
        #${GUI_PANEL_ID} .sel-row{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
        #${GUI_PANEL_ID} .sel-sum{margin-left:auto;font-size:12px;color:var(--ace-text-muted)}
        #${GUI_PANEL_ID} .list{
          border:1px solid var(--ace-glass-border);border-radius:calc(var(--ace-radius) - 1px);
          background:hsl(var(--background, 36 45% 98%) / .40);max-height:280px;overflow-y:auto;
          backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px)
        }
        #${GUI_PANEL_ID} .empty{padding:12px;font-size:12px;color:var(--ace-text-muted)}
        #${GUI_PANEL_ID} .item{display:flex;gap:9px;align-items:flex-start;padding:9px 10px;border-top:1px solid var(--ace-glass-border);cursor:pointer}
        #${GUI_PANEL_ID} .item:first-child{border-top:none}
        #${GUI_PANEL_ID} .item:hover{background:hsl(var(--foreground, 24 6% 17%) / .06)}
        #${GUI_PANEL_ID} .item-main{min-width:0;flex:1}
        #${GUI_PANEL_ID} .item-title{font-size:13px;line-height:1.35;word-break:break-word;color:var(--ace-text)}
        #${GUI_PANEL_ID} .item-meta{margin-top:3px;font-size:11px;color:var(--ace-text-muted)}
        #${GUI_PANEL_ID} .status{
          border-radius:calc(var(--ace-radius) - 2px);padding:8px 10px;font-size:12px;border:1px solid var(--ace-glass-border);
          background:var(--ace-glass-soft);color:var(--ace-text-secondary);
          backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px)
        }
        #${GUI_PANEL_ID} .status[data-type="success"]{border-color:hsl(var(--interactive-positive, 125 49% 43%) / .24);background:hsl(var(--interactive-positive, 125 49% 43%) / .10);color:var(--ace-positive)}
        #${GUI_PANEL_ID} .status[data-type="error"]{border-color:hsl(var(--interactive-negative, 2 63% 54%) / .24);background:hsl(var(--interactive-negative, 2 63% 54%) / .10);color:var(--ace-negative)}
        #${GUI_PANEL_ID} .status[data-type="loading"]{border-color:hsl(var(--foreground, 24 6% 17%) / .18);background:hsl(var(--foreground, 24 6% 17%) / .06);color:var(--ace-text-secondary)}
        #${GUI_PANEL_ID}[data-busy="true"] button,#${GUI_PANEL_ID}[data-busy="true"] input[type="checkbox"]{opacity:.64}
      `;
      document.head.appendChild(style);

      const root = document.createElement("div");
      root.id = GUI_ROOT_ID;
      root.innerHTML = `
        <button id="${GUI_DOCK_BUTTON_ID}" type="button" aria-label="${t("dock_aria_open")}">
          <span class="t1">${t("dock_primary")}</span><span class="t2">${t("dock_secondary")}</span>
        </button>
        <section id="${GUI_PANEL_ID}" data-open="false" data-busy="false" aria-hidden="true">
          <div class="head">
            <div><div class="title">${t("panel_title")}</div></div>
            <button class="close" type="button" data-role="close" aria-label="${t("close_aria")}">×</button>
          </div>
          <div class="body">
            <div class="sec">
              <div class="sec-t">${t("section_current")}</div>
              <div class="row2">
                <button class="btn em" type="button" data-role="export-current-json">${t("button_download_json")}</button>
                <button class="btn" type="button" data-role="export-current-txt">${t("button_download_txt")}</button>
              </div>
            </div>
            <div class="sec">
              <div class="sec-h">
                <div class="sec-t">${t("section_history")}</div>
                <button class="btn" type="button" data-role="fetch-history">${t("button_fetch_history")}</button>
              </div>
              <div class="helper">${t("helper_history")}</div>
              <div class="sel-row">
                <button class="btn" type="button" data-role="select-all">${t("button_select_all")}</button>
                <button class="btn" type="button" data-role="clear-selection">${t("button_clear_selection")}</button>
                <span class="sel-sum" data-role="selection-summary">${t("selected_count", { count: 0 })}</span>
              </div>
              <div class="list" data-role="history-list"><div class="empty">${t("history_empty")}</div></div>
              <div class="row2">
                <button class="btn em" type="button" data-role="export-selected-json">${t("button_export_selected_json")}</button>
                <button class="btn" type="button" data-role="export-selected-txt">${t("button_export_selected_txt")}</button>
              </div>
            </div>
            <div id="${GUI_STATUS_ID}" class="status" data-type="info">${t("status_prefix", { message: t("status_ready") })}</div>
          </div>
        </section>
      `;
      document.body.appendChild(root);

      const dockButton = document.getElementById(GUI_DOCK_BUTTON_ID);
      const panel = document.getElementById(GUI_PANEL_ID);
      const statusNode = document.getElementById(GUI_STATUS_ID);
      const closeNode = panel?.querySelector('[data-role="close"]');
      const exportCurrentJsonNode = panel?.querySelector('[data-role="export-current-json"]');
      const exportCurrentTxtNode = panel?.querySelector('[data-role="export-current-txt"]');
      const fetchHistoryNode = panel?.querySelector('[data-role="fetch-history"]');
      const selectAllNode = panel?.querySelector('[data-role="select-all"]');
      const clearSelectionNode = panel?.querySelector('[data-role="clear-selection"]');
      const exportSelectedJsonNode = panel?.querySelector('[data-role="export-selected-json"]');
      const exportSelectedTxtNode = panel?.querySelector('[data-role="export-selected-txt"]');
      const historyListNode = panel?.querySelector('[data-role="history-list"]');
      const selectionSummaryNode = panel?.querySelector('[data-role="selection-summary"]');

      if (
        !dockButton ||
        !panel ||
        !statusNode ||
        !exportCurrentJsonNode ||
        !exportCurrentTxtNode ||
        !fetchHistoryNode ||
        !selectAllNode ||
        !clearSelectionNode ||
        !exportSelectedJsonNode ||
        !exportSelectedTxtNode ||
        !historyListNode ||
        !selectionSummaryNode
      ) {
        warn(t("gui_init_failed"));
        return;
      }

      const state = {
        isBusy: false,
        historyItems: [],
        selectedKeys: new Set(),
      };

      function setStatus(message, type) {
        statusNode.textContent = t("status_prefix", { message });
        statusNode.setAttribute("data-type", type || "info");
      }

      function setBusy(nextBusy) {
        state.isBusy = Boolean(nextBusy);
        panel.setAttribute("data-busy", state.isBusy ? "true" : "false");
        dockButton.setAttribute("data-busy", state.isBusy ? "true" : "false");
      }

      function setPanelOpen(nextOpen) {
        const isOpen = Boolean(nextOpen);
        panel.setAttribute("data-open", isOpen ? "true" : "false");
        panel.setAttribute("aria-hidden", isOpen ? "false" : "true");
        dockButton.setAttribute("data-open", isOpen ? "true" : "false");
      }

      function updateSelectionSummary() {
        selectionSummaryNode.textContent = t("selected_count", { count: state.selectedKeys.size });
      }

      // The list only shows readable business fields; internal UUIDs stay hidden from the GUI.
      function renderHistoryList() {
        historyListNode.innerHTML = "";
        if (!state.historyItems.length) {
          historyListNode.innerHTML = `<div class="empty">${t("history_empty")}</div>`;
          updateSelectionSummary();
          return;
        }

        const fragment = document.createDocumentFragment();
        for (const item of state.historyItems) {
          const row = document.createElement("label");
          row.className = "item";
          row.innerHTML = `
            <input type="checkbox" />
            <div class="item-main">
              <div class="item-title"></div>
              <div class="item-meta"></div>
            </div>
          `;
          const checkbox = row.querySelector('input[type="checkbox"]');
          const titleNode = row.querySelector(".item-title");
          const metaNode = row.querySelector(".item-meta");
          if (!checkbox || !titleNode || !metaNode) {
            continue;
          }
          titleNode.textContent = truncateText(item.title || t("untitled"), 92);
          metaNode.textContent = `${item.type === "agentic" ? "agentic" : item.mode || "unknown"} | ${formatUiTime(item.createdAt)}`;
          const itemKey = getHistoryItemKey(item);
          checkbox.checked = state.selectedKeys.has(itemKey);
          checkbox.addEventListener("change", () => {
            if (checkbox.checked) {
              state.selectedKeys.add(itemKey);
            } else {
              state.selectedKeys.delete(itemKey);
            }
            updateSelectionSummary();
          });
          fragment.appendChild(row);
        }
        historyListNode.appendChild(fragment);
        updateSelectionSummary();
      }

      async function runGuiAction(label, task) {
        if (state.isBusy) {
          return;
        }
        setBusy(true);
        setStatus(t("status_running", { label }), "loading");
        try {
          const message = await task();
          setStatus(message || t("status_done", { label }), "success");
        } catch (error) {
          const message = toErrorMessage(error);
          warn("gui action failed", label, message);
          setStatus(t("status_failed", { label, message }), "error");
        } finally {
          setBusy(false);
        }
      }

      async function handleFetchHistory() {
        await runGuiAction(t("label_fetch_history"), async () => {
          const history = await fetchHistoryList(HISTORY_PAGE_GUARD, false, {
            onPageRequest(progress) {
              setStatus(
                t("fetch_page_request", {
                  page: progress.page,
                  count: progress.totalCount,
                }),
                "loading"
              );
            },
            onPageLoaded(progress) {
              setStatus(
                t("fetch_page_loaded", {
                  page: progress.page,
                  count: progress.totalCount,
                }),
                "loading"
              );
            },
          });
          const mapped = history
            .filter((item) => (item?.type === "evaluation" || item?.type === "agentic" || !item?.type) && extractConversationId(item?.id))
            .map((item) => ({
              id: extractConversationId(item.id),
              type: item?.type === "agentic" ? "agentic" : "evaluation",
              title: String(item?.title || t("untitled")),
              mode: String(item?.mode || "unknown"),
              createdAt: item?.createdAt || "",
              updatedAt: item?.updatedAt || "",
            }));
          state.historyItems = mapped;
          state.selectedKeys.clear();
          renderHistoryList();
          if (history.length >= HISTORY_PAGE_GUARD * DEFAULT_HISTORY_PAGE_SIZE) {
            return t("fetch_guard_hit", { count: state.historyItems.length });
          }
          return t("fetch_complete", { count: state.historyItems.length });
        });
      }

      async function handleExportCurrent(format) {
        const formatLabel = format === "txt" ? "TXT" : "JSON";
        await runGuiAction(t("label_download_current", { format: formatLabel }), async () => {
          await exportCurrentConversation(format);
          return t("current_download_done", { format: formatLabel });
        });
      }

      async function handleExportSelected(format) {
        const formatLabel = format === "txt" ? "TXT" : "JSON";
        await runGuiAction(t("label_export_selected", { format: formatLabel }), async () => {
          const selectedItems = state.historyItems.filter((item) => state.selectedKeys.has(getHistoryItemKey(item)));
          if (!selectedItems.length) {
            throw new Error(t("no_selected_items"));
          }
          const result = await exportBatchConversations(selectedItems, format, {
            onProgress(progress) {
              setStatus(
                t("status_running", {
                  label: `${t("label_export_selected", { format: formatLabel })} ${progress.index}/${progress.total}`,
                }),
                "loading"
              );
            },
            onZipProgressStart() {
              setStatus(t("zip_packing", { format: formatLabel }), "loading");
            },
            onZipProgress(metadata) {
              const percent = Math.max(0, Math.min(100, Math.round(Number(metadata?.percent || 0))));
              setStatus(t("zip_packing_progress", { format: formatLabel, percent }), "loading");
            },
          });
          if (result.failedCount > 0) {
            if (result.packaged) {
              return t("batch_done_packaged_success_failed", {
                success: result.successCount,
                failed: result.failedCount,
              });
            }
            return t("batch_done_success_failed", {
              success: result.successCount,
              failed: result.failedCount,
            });
          }
          if (result.packaged) {
            return t("batch_done_packaged_success", { success: result.successCount });
          }
          return t("batch_done_success", { success: result.successCount });
        });
      }

      dockButton.addEventListener("click", () => {
        const isOpen = panel.getAttribute("data-open") === "true";
        setPanelOpen(!isOpen);
      });
      closeNode?.addEventListener("click", () => setPanelOpen(false));

      exportCurrentJsonNode.addEventListener("click", () => handleExportCurrent("json"));
      exportCurrentTxtNode.addEventListener("click", () => handleExportCurrent("txt"));
      fetchHistoryNode.addEventListener("click", () => handleFetchHistory());

      selectAllNode.addEventListener("click", () => {
        for (const item of state.historyItems) {
          state.selectedKeys.add(getHistoryItemKey(item));
        }
        renderHistoryList();
        setStatus(t("selected_all_done"), "info");
      });
      clearSelectionNode.addEventListener("click", () => {
        state.selectedKeys.clear();
        renderHistoryList();
        setStatus(t("cleared_selection_done"), "info");
      });

      exportSelectedJsonNode.addEventListener("click", () => handleExportSelected("json"));
      exportSelectedTxtNode.addEventListener("click", () => handleExportSelected("txt"));

      document.addEventListener("click", (event) => {
        if (panel.getAttribute("data-open") !== "true") {
          return;
        }
        const target = event.target;
        if (!(target instanceof Node)) {
          return;
        }
        if (panel.contains(target) || dockButton.contains(target)) {
          return;
        }
        setPanelOpen(false);
      });
      document.addEventListener("keydown", (event) => {
        if (event.key === "Escape" && panel.getAttribute("data-open") === "true") {
          setPanelOpen(false);
        }
      });

      renderHistoryList();
      setStatus(t("status_ready"), "info");
    };

    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", mount, { once: true });
    } else {
      mount();
    }
  }

  installGui();

  // 低层接口保留给控制台脚本调用；默认 GUI 不展示 UUID 等底层字段。
  window.__arenaChatExport = async function __arenaChatExport(conversationId, format, type) {
    return await exportHistoryItem(
      {
        id: conversationId,
        type: type === "agentic" ? "agentic" : "evaluation",
      },
      format || "json"
    );
  };

  log("ready");
})();
