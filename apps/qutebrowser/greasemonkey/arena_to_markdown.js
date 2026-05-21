// ==UserScript==
// @name         ChatGPT/Claude/Grok/Arena | Conversation/Chat Markdown Export/Download
// @namespace    https://greasyfork.org/en/users/1462137-piknockyou
// @version      10.22
// @author       Piknockyou (vibe-coded)
// @license      AGPL-3.0
// @description  Export AI chat conversations to Markdown. Supports ChatGPT, Claude.ai, Grok.com, and Arena.ai. Features: one-click export, clean Markdown output, draggable button, configurable settings, and support for artifacts, attachments, thinking/reasoning, code blocks, search results, citations, and model attribution.
// @match        *://chatgpt.com/*
// @match        *://claude.ai/*
// @match        *://grok.com/*
// @match        *://lmarena.ai/*
// @match        *://arena.ai/*
// @match        *://canaryarena.ai/*
// @icon         data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23fff' stroke-width='2'><path d='M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'/><polyline points='7 10 12 15 17 10'/><line x1='12' y1='15' x2='12' y2='3'/></svg>
// @grant        GM_setValue
// @grant        GM_getValue
// @grant        GM_deleteValue
// @grant        GM_xmlhttpRequest
// @connect      chatgpt.com
// @connect      claude.ai
// @connect      grok.com
// @connect      arena.ai
// @connect      canaryarena.ai
// @connect      r2.cloudflarestorage.com
// @run-at       document-idle
// @downloadURL https://update.greasyfork.org/scripts/559376/ChatGPTClaudeGrokArena%20%7C%20ConversationChat%20Markdown%20ExportDownload.user.js
// @updateURL https://update.greasyfork.org/scripts/559376/ChatGPTClaudeGrokArena%20%7C%20ConversationChat%20Markdown%20ExportDownload.meta.js
// ==/UserScript==

// ═══════════════════════════════════════════════════════════════════════
// CHANGELOG
// ═══════════════════════════════════════════════════════════════════════
// v10.22
// - Added (Claude): Full support for exporting Claude 'visualize' widgets (SVG). Intercepts rendered widget data via a background listener and offers multiple embedding options (Markdown, HTML, Data URIs).
// - Added (Claude): Pre-export Widget Capture Dialog. Detects missing widgets and prompts the user to download them before generating the Markdown.
// - Added (ChatGPT): Support for extracting and formatting ChatGPT's new "Thoughts" (reasoning) blocks.
// - Added (Settings): Master toggles for "Include Images", "Include Widgets", and "Include Web Features" that intelligently bulk-toggle their nested sub-options.
// - Added (Settings): Nested UI subsections for granular control over visual media embedding formats (Markdown Inline, HTML Inline, Links, and Wrappers).
// - Added (Images): Expanded image settings to include HTML `<img>` tags (Base64/Remote), distinct Web vs. File clickable links, and a "Collapsible Images" wrapper.
// - Changed: Unified the provider-specific regeneration settings (e.g., CHATGPT_EXPORT_ALL_REGENERATIONS) into a single, global `EXPORT_ALL_REGENERATIONS` flag.
// - Improved: Stricter filename and path sanitization (`sanitizeFilesystemName`) to strip forbidden OS control characters, preventing broken downloads.
// - Improved: Major codebase refactoring for better organization. Provider-specific components (caches, dialogs) are now safely nested inside their respective Provider objects.
//
// v10.21
// - Changed: Image options are now 5 fully independent checkboxes (no gray/lock coupling in settings UI).
// - Changed: Relative-path inline images trigger the image download pass without forcing the Download checkbox state.
// - Changed: Export download pass deduplicates naturally when both Download Files and Relative Path are enabled.
// - Removed: Legacy image compatibility path (INCLUDE_IMAGES / IMAGE_EXPORT_MODE) from runtime settings handling.
// - Improved: Settings tooltips appear faster on hover.
//
// v10.20
// - Changed: Replaced image mode dropdown with 5 explicit image checkboxes (download, inline relative, inline base64, inline remote URL, clickable link).
// - Refactor: Unified image option behavior across Arena and ChatGPT; images can be exported independently of tool-call toggles.
// - Compatibility: Added temporary migration path for older image settings (now removed in v10.21).
//
// v10.19
// - Added: ChatGPT image export mode support (superseded by checkbox model in v10.20+).
// - Fixed: ChatGPT images no longer depend on tool-call visibility toggles.
// - Refactor: Image download utility is now shared (Arena + ChatGPT) for consistent blob/base64 handling.
//
// v10.18
// - Improved: ChatGPT image export now prefers signed estuary URLs discovered from the live DOM (img/a src by file_id), fixing broken bare-id links.
// - Added: ChatGPT image fallback note when no signed URL is available in DOM at export time.
//
// v10.17
// - Added: ChatGPT settings menu now includes Sources List controls (Include Sources List + Collapsible Sources List).
// - Added: ChatGPT image tool outputs now include a direct estuary image link derived from sediment asset_pointer file IDs.
// - Documentation: Updated provider matrix/notes to reflect ChatGPT sources-list and image-link support.
//
// v10.16
// - Fixed: ChatGPT citation artifact cleanup now removes residual marker glyphs/tofu and dangling digits from partial marker spans.
// - Improved: ChatGPT tool activity now renders inline in turn order (before final assistant text) to match on-page flow better.
// - Fixed: ChatGPT tool Input/Output rendering avoids nested fenced code blocks for code/execution outputs.
//
// v10.15
// - Improved: ChatGPT export now normalizes true chat turns (internal tool plumbing is grouped under assistant turns instead of becoming standalone turns).
// - Improved: ChatGPT citations now use metadata.content_references for inline linked superscripts and per-message source lists.
// - Fixed: ChatGPT "Export all regenerations" now follows conversation tree order (avoids timestamp-only misordering with null-time nodes).
//
// v10.14
// - Fixed: Corrected minor typos in onboarding banner and internal stats logic.
//
// v10.13
// - Documentation: Polished support matrix, config labels, and comments across the file to properly establish ChatGPT as a first-class provider.
//
// v10.12
// - Added: Support for ChatGPT (via backend-api extraction). Includes web search, code execution, and correct conversation tree following.
//
// v10.10
// - Fixed: Relative image path references file directly (no images/ subfolder)
//
// v10.9
// - Changed: Image export now supports 3 modes: Base64 embed, Base64 + separate file, Separate file + relative path (default)
// - Removed: Image size limit (was 5MB)
// - Added: Separate image file download alongside or instead of Markdown embedding
//
// v10.8
// - Added: Arena image export — downloads and embeds generated/attached images as base64 data URIs
// - Added: INCLUDE_IMAGES setting toggle (Arena provider)
//
// v10.7
// - Improved: Claude tool call formatting now pairs tool_use + tool_result into one block (consistent Input/Output)
// - Fixed: bash_tool input now falls back to display_content.json_block when command is missing/empty
// - Added: Claude setting to toggle embedding `files_v2` file contents (download-file) separately from attachments
//
// v10.6
// - Fixed: Claude uploads in `files_v2` now export (with optional inline content via wiggle/download-file)
// - Added: Claude tool exports for view/bash_tool/present_files/create_file result with consistent Input/Output formatting
// - Added: Claude settings toggles for tool exports (Include Tool Calls / Collapsible Tool Calls)
//
// v10.5
// - Fixed: Claude artifacts now export correctly (new `create_file` tool format)
// - Added: Export of bash/shell tool commands and outputs
// - Added: Export of presented files indicator
//
// v10.4
// - Fixed: Export button no longer disappears during long Arena.ai reloads (React rerenders/scroll-to-bottom)
// - Added: Shadow DOM encapsulation for the export button icon (stronger isolation)
// - Added: Watchdog re-attachment if the button is removed from DOM
//
// v10.3
// - Fixed: Arena dual-model modes (both "side-by-side" and "battle") now correctly detected
//   Previously only "battle" was recognized; "side-by-side" was misdetected as direct mode
// - Fixed: Model names now correctly mapped to responses via participantPosition
//           (position 'a' = left/first model, position 'b' = right/second model)
//
// v10.2
// - Added @match *://canaryarena.ai/*
// - Added @connect canaryarena.ai
//
// v10.1
// - LMArena renamed to Arena

(() => {
	// ═══════════════════════════════════════════════════════════════════════════
	// DEVELOPER NOTE: CODE ORGANIZATION
	// ═══════════════════════════════════════════════════════════════════════════
	//
	// This script follows a provider-centric organization:
	//
	// 1. SHARED CODE (globals, config, utils) — placed BEFORE provider sections
	//    - CONFIG, PROVIDER_FLAGS, FLAG_METADATA, Settings, Utils, etc.
	//    - These are used by all providers and should remain at the top.
	//
	// 2. PROVIDER-SPECIFIC CODE — placed INSIDE the provider object
	//    - Each provider (ChatGPT, Claude, Grok, Arena) is a self-contained object.
	//    - Provider-specific helpers, caches, dialogs, etc. should be NESTED
	//      inside the provider object, not floating in global scope.
	//    - Example: Claude's WidgetCache and WidgetCaptureDialog are nested
	//      inside ClaudeProvider, not standalone globals.
	//
	// 3. UI/ROUTING CODE (shared) — placed AFTER provider sections
	//    - SettingsPanel, Router, ButtonManager, etc.
	//    - These coordinate between providers but don't contain provider logic.
	//
	// WHEN ADDING NEW FEATURES:
	//    - If it's provider-specific → nest it inside the provider object
	//    - If it's shared by multiple providers → place in shared section
	//    - If it's UI/routing → place in UI section at the end
	//
	// ═══════════════════════════════════════════════════════════════════════════
	// CONFIGURATION & PROVIDER REFERENCE
	// ═══════════════════════════════════════════════════════════════════════════
	//
	// This is the single source of truth for:
	//   1. All configuration flags and their default values
	//   2. Provider support matrix (which flags apply to which provider)
	//   3. Provider-specific behavior notes
	//   4. Guide for adding new providers
	//
	// ───────────────────────────────────────────────────────────────────────────
	// PROVIDER SUPPORT MATRIX
	// ───────────────────────────────────────────────────────────────────────────
	//
	// Legend:  T = ChatGPT   C = Claude    G = Grok    L = Arena
	//          ✓ = Supported            · = Not applicable / No effect
	//
	// MESSAGE CONTENT                              T   C   G   L   Notes
	// ─────────────────────────────────────────────────────────────────
	// INCLUDE_USER_MESSAGES                        ✓   ✓   ✓   ✓
	// INCLUDE_ASSISTANT_MESSAGES                   ✓   ✓   ✓   ✓
	// INCLUDE_THINKING                             ·   ✓   ·   ✓   [1]
	// COLLAPSIBLE_THINKING                         ·   ✓   ·   ✓
	// INCLUDE_ATTACHMENTS                          ·   ✓   ✓   ·
	// CLAUDE_EMBED_FILES_V2_CONTENT                ·   ✓   ·   ·   [6]
	// COLLAPSIBLE_ATTACHMENTS                      ·   ✓   ✓   ·
	// INCLUDE_ARTIFACTS                            ·   ✓   ·   ·
	// COLLAPSIBLE_ARTIFACTS                        ·   ✓   ·   ·
	// INCLUDE_CODE_BLOCKS                          ✓   ✓   ✓   ✓
	// COLLAPSIBLE_CODE_BLOCKS                      ✓   ✓   ✓   ✓
	//
	// IMAGES                                       T   C   G   L   Notes
	// ─────────────────────────────────────────────────────────────────
	// IMAGE_DOWNLOAD_FILES                         ✓   ·   ·   ✓   [8][9]
	// IMAGE_MD_RELATIVE_PATH                       ✓   ·   ·   ✓   [8][9]
	// IMAGE_MD_BASE64                              ✓   ·   ·   ✓   [8][9]
	// IMAGE_MD_REMOTE_URL                          ✓   ·   ·   ✓   [8][9]
	// IMAGE_HTML_IMG_BASE64                        ✓   ·   ·   ✓   [8][9]
	// IMAGE_HTML_IMG_REMOTE                        ✓   ·   ·   ✓   [8][9]
	// IMAGE_CLICKABLE_WEB_LINK                     ✓   ·   ·   ✓   [8][9]
	//
	// WIDGETS                                      T   C   G   L   Notes
	// ─────────────────────────────────────────────────────────────────
	// WIDGET_MD_RELATIVE_PATH                      ·   ✓   ·   ·   [10]
	// WIDGET_MD_BASE64                             ·   ✓   ·   ·   [10]
	// WIDGET_MD_DATAURI_TEXT                       ·   ✓   ·   ·   [10]
	// WIDGET_HTML_SVG_RAW                          ·   ✓   ·   ·   [10]
	// WIDGET_HTML_IMG_BASE64                       ·   ✓   ·   ·   [10]
	// WIDGET_HTML_IMG_DATAURI                      ·   ✓   ·   ·   [10]
	// WIDGET_CLICKABLE_LINK                        ·   ✓   ·   ·   [10]
	// COLLAPSIBLE_WIDGETS                          ·   ✓   ·   ·   [10]
	//
	// TOOLS                                        T   C   G   L   Notes
	// ─────────────────────────────────────────────────────────────────
	// INCLUDE_TOOL_CALLS                           ✓   ✓   ·   ·   [7]
	// COLLAPSIBLE_TOOL_CALLS                       ✓   ✓   ·   ·
	//
	// WEB SEARCH                                   T   C   G   L   Notes
	// ─────────────────────────────────────────────────────────────────
	// INCLUDE_SEARCH_QUERIES                       ✓   ✓   ·   ·   [2]
	// INCLUDE_SEARCH_RESULTS                       ✓   ✓   ·   ·   [2]
	// COLLAPSIBLE_SEARCH_RESULTS                   ✓   ✓   ·   ·
	// INCLUDE_SOURCES                              ✓   ✓   ·   ✓   [3]
	// INCLUDE_SOURCES_LIST                         ✓   ✓   ✓   ✓
	// COLLAPSIBLE_SOURCES_LIST                     ✓   ✓   ✓   ✓
	//
	// METADATA                                     T   C   G   L   Notes
	// ─────────────────────────────────────────────────────────────────
	// INCLUDE_MODEL_INFO                           ✓   ✓   ✓   ✓   [4]
	// INCLUDE_THINKING_DURATION                    ·   ·   ✓   ·
	// INCLUDE_TIMESTAMPS                           ✓   ✓   ✓   ✓
	// INCLUDE_MESSAGE_IDS                          ✓   ✓   ✓   ✓
	//
	// HEADER & FORMATTING                          T   C   G   L   Notes
	// ─────────────────────────────────────────────────────────────────
	// INCLUDE_HEADER                               ✓   ✓   ✓   ✓
	// INCLUDE_ACTIVE_LEAF_INFO                     ✓   ✓   ✓   ·   [5]
	// INCLUDE_TURN_NUMBERS                         ✓   ✓   ✓   ✓
	// COLLAPSIBLE_MESSAGES                         ✓   ✓   ✓   ✓
	//
	// BRANCHING                                    T   C   G   L   Notes
	// ─────────────────────────────────────────────────────────────────
	// EXPORT_ALL_REGENERATIONS                     ✓   ✓   ✓   ·
	//
	// ───────────────────────────────────────────────────────────────────────────
	// PROVIDER-SPECIFIC BEHAVIOR NOTES
	// ───────────────────────────────────────────────────────────────────────────
	//
	// [1] THINKING
	//     Claude:  "thinking" content blocks in API response
	//     Arena:   "reasoning" field on assistant messages
	//     Grok:    No thinking content; use INCLUDE_THINKING_DURATION instead
	//
	// [2] SEARCH QUERIES & RESULTS (Claude & ChatGPT)
	//     Queries: tool_use blocks (Claude: web_search) / metadata queries (ChatGPT: web.run)
	//     Results: tool_result blocks containing URLs (Claude) / metadata search_result_groups (ChatGPT)
	//
	// [3] INLINE CITATIONS (INCLUDE_SOURCES)
	//     Claude:  [[Title]](url) superscripts at end_index positions
	//     Arena:   [1], [2], [3] numeric superscripts at charLocation positions
	//     Grok:    No position data; inline citations not possible (list only)
	//     ChatGPT: Uses metadata.content_references to inject linked numeric superscripts
	//              and removes proprietary marker glyphs from exported text.
	//
	// [4] MODEL INFO
	//     ChatGPT: Included via msg.metadata.model_slug
	//     Claude:  Available at conversation level (data.model)
	//     Grok:    Available in response.model field
	//     Arena:   Scraped from DOM (API only provides UUIDs)
	//              - Direct mode: Sequential assistant index mapping
	//              - Battle mode: participantPosition 'a'/'b' mapping
	//              - DOM uses flex-col-reverse; reversed for direct mode
	//
	// [5] ACTIVE LEAF INFO
	//     ChatGPT: current_node UUID (active conversation tree position)
	//     Claude:  current_leaf_message_uuid (conversation tree position)
	//     Grok:    Active rid from URL parameter (?rid=...)
	//     Arena:   Linear conversation structure, no branching concept
	//
	// [6] CLAUDE_EMBED_FILES_V2_CONTENT
	//     When enabled, downloads file contents from Claude's wiggle/download-file endpoint
	//     for files_v2 uploads. Disabled = exports only metadata (name/path/uuid).
	//     Gated by INCLUDE_ATTACHMENTS.
	//
	// [7] TOOL CALLS (Claude & ChatGPT)
	//     Claude:  Exports tool_use + tool_result blocks. Pairs input/output into single blocks.
	//     ChatGPT: Exports tool execution input and outputs (e.g., Python code interpreter).
	//
	// [8] IMAGES (Arena)
	//     Downloads image attachments (experimental_attachments) from signed URLs.
	//     Signed URLs expire (~1h), so images are fetched at export time when needed.
	//     Image behavior is controlled by 7 independent checkboxes organized in subsections:
	//       - Download: Download image files (separate .png/.jpg files)
	//       - Markdown Inline: ![](file.ext), ![](data:base64), ![](remote URL)
	//       - HTML Inline: <img src="data:base64">, <img src="remote URL">
	//       - Link: Clickable link line
	//     If multiple options are enabled, images are fetched once and file downloads are deduplicated.
	//
	// [9] IMAGES (ChatGPT)
	//     ChatGPT image tool outputs expose sediment://file_* asset pointers.
	//     Export resolves signed estuary links from current DOM when available:
	//       /backend-api/estuary/content?id=file_...&ts=...&p=...&cid=...&sig=...&v=...
	//     Fallback (when signed URL is not found in DOM):
	//       /backend-api/estuary/content?id=file_...
	//     Uses the same 7 independent image checkboxes as Arena ([8]) with identical behavior.
	//
	// [10] WIDGETS (Claude)
	//     Claude visualize:show_widget renders SVG inside a cross-origin MCP iframe.
	//     The rendered SVG is captured via the MCP ui/download-file message when the
	//     user clicks "Download file" on the widget. An always-on background listener
	//     caches SVGs by title for the session. At export time, a dialog lists detected
	//     widgets with capture status, lets the user select which to include, and
	//     provides instructions to capture any missing ones.
	//
	//     IMPORTANT: Users must manually download widget SVGs via Claude's "Download file"
	//     button. The script does NOT download .svg files — browser saves to ~/Downloads,
	//     and programmatic download would create duplicates in the same location.
	//     WidgetCache is used only for inline embedding (base64, data URI, raw SVG).
	//
	//     Widget behavior is controlled by 9 independent checkboxes organized in subsections:
	//       - Markdown Inline: ![](file.svg), ![](data:base64), ![](data:utf-8,<svg>...)
	//       - HTML Inline: <svg>...</svg>, <img src="data:base64">, <img src="data:utf-8">
	//       - Link: Clickable link line
	//       - Wrapper: Collapsible section
	//
	//     Raw widget_code is NOT used — it depends on Claude runtime CSS/classes.
	//     If a widget's SVG was not captured, export continues with a fallback note.
	//     visualize:read_me blocks are skipped entirely (internal MCP plumbing).
	//
	// ───────────────────────────────────────────────────────────────────────────
	// ADDING A NEW PROVIDER — CHECKLIST
	// ───────────────────────────────────────────────────────────────────────────
	//
	// When implementing a new provider, complete ALL of the following steps:
	//
	// NOTE: First-run Onboarding Banner
	//   The script shows a one-time onboarding banner (dismissible) explaining:
	//     - Left-click export
	//     - Right-click settings
	//     - Right-drag move
	//     - Supported providers
	//
	//   Implementation is centralized in `OnboardingBanner`:
	//     - Declarative content in OnboardingBanner.CONTENT (single source of truth)
	//     - Styles injected once (idempotent) with OnboardingBanner.STYLES_ID
	//     - Provider icons loaded via FaviconLoader (CSP-safe) from CONTENT.providers
	//     - Dismissal uses CONFIG.HINT_DISMISSED_KEY (stored in localStorage)
	//
	//   When adding a new provider, update OnboardingBanner.CONTENT.providers array.
	//
	// STEP 1: GATHER INFORMATION
	//   □ Sample API/JSON response from the chat endpoint (DevTools → Network)
	//   □ Sample HTML of the chat page (if DOM scraping is needed)
	//   □ URL patterns for chat pages (e.g., /chat/{id}, /c/{id})
	//
	// STEP 2: IDENTIFY APPLICABLE FLAGS
	//   Review each CONFIG flag category and determine support:
	//   □ User/Assistant messages (almost always yes)
	//   □ Thinking/reasoning blocks (check for "reasoning", "thinking" fields)
	//   □ File attachments (uploaded files with content)
	//   □ Artifacts (code/content generation blocks)
	//   □ Web search (tool calls, search results, citations)
	//   □ Inline citations (requires position data like end_index, charLocation)
	//   □ Model info (in API response, or needs DOM scraping?)
	//   □ Timestamps, message IDs
	//   □ Branching/regenerations (conversation tree structure)
	//
	// STEP 3: UPDATE THIS FILE — CONFIG SECTION
	//   □ Update the PROVIDER SUPPORT MATRIX above (add column for new provider)
	//   □ Add any provider-specific flags (e.g., NEWPROVIDER_EXPORT_ALL_REGENS)
	//   □ Add behavior notes if the provider has unique handling
	//
	// STEP 4: UPDATE PROVIDER_FLAGS ARRAY
	//   □ Add new provider entry listing all applicable flag names
	//   □ Order flags logically (matches settings panel display order)
	//
	// STEP 5: UPDATE FLAG_METADATA
	//   □ Add provider-specific labels if wording differs (e.g., "Citations" vs "Sources")
	//   □ Add provider-specific tooltips explaining unique behavior
	//
	// STEP 6: IMPLEMENT PROVIDER MODULE
	//   Create provider object with required interface:
	//   □ name: string (display name, e.g., "NewProvider")
	//   □ hostPattern: RegExp (matches the site's domain)
	//   □ matches(url): boolean
	//   □ extractChatId(url): string | null
	//   □ fetchChat(chatId): Promise<object>
	//   □ generateMarkdown(data, settings): { content, filename, stats }
	//
	// STEP 7: REGISTER PROVIDER
	//   □ Add to Providers.list array
	//   □ Add @match directive to userscript header
	//
	// STEP 8: TEST
	//   □ Verify all applicable flags work correctly
	//   □ Test settings panel shows correct options
	//   □ Test export produces valid Markdown
	//
	// ═══════════════════════════════════════════════════════════════════════════

	const CONFIG = {
		// ─── Message Content ─────────────────────────────────────────────────
		INCLUDE_USER_MESSAGES: true,
		INCLUDE_ASSISTANT_MESSAGES: true,
		INCLUDE_THINKING: true,
		COLLAPSIBLE_THINKING: true,
		INCLUDE_ATTACHMENTS: true,
		CLAUDE_EMBED_FILES_V2_CONTENT: true,
		COLLAPSIBLE_ATTACHMENTS: true,
		INCLUDE_ARTIFACTS: true,
		COLLAPSIBLE_ARTIFACTS: true,
		INCLUDE_CODE_BLOCKS: true,
		COLLAPSIBLE_CODE_BLOCKS: true,
		// ─── Images (ChatGPT + Arena) ────────────────────────────────────────
		INCLUDE_IMAGES: true,
		// Download
		IMAGE_DOWNLOAD_FILES: true,
		// Markdown inline
		IMAGE_MD_RELATIVE_PATH: true,
		IMAGE_MD_BASE64: false,
		IMAGE_MD_REMOTE_URL: false,
		// HTML inline
		IMAGE_HTML_IMG_BASE64: false,
		IMAGE_HTML_IMG_REMOTE: false,
		// Link
		IMAGE_CLICKABLE_WEB_LINK: false,
		IMAGE_CLICKABLE_FILE_LINK: false,
		// Wrapper
		COLLAPSIBLE_IMAGES: true,

		// ─── Widgets (Claude) ────────────────────────────────────────────────
		INCLUDE_WIDGETS: false,
		// Download: Disabled — user must manually download SVGs via Claude's "Download file" button.
		// The browser saves to ~/Downloads; programmatic download would create duplicates in same location.
		// TODO: Re-enable if auto-download from iframe becomes feasible (e.g., intercept and route to custom location).
		// WIDGET_DOWNLOAD_FILES: true,
		// Markdown inline
		WIDGET_MD_RELATIVE_PATH: true,
		WIDGET_MD_BASE64: false,
		WIDGET_MD_DATAURI_TEXT: false,
		// HTML inline
		WIDGET_HTML_SVG_RAW: false,
		WIDGET_HTML_IMG_BASE64: false,
		WIDGET_HTML_IMG_DATAURI: false,
		// Link
		WIDGET_CLICKABLE_LINK: false,
		// Wrapper
		COLLAPSIBLE_WIDGETS: true,

		// ─── Tools (Claude & ChatGPT) ───────────────────────────────────────
		INCLUDE_TOOL_CALLS: true,
		COLLAPSIBLE_TOOL_CALLS: true,

		// ─── Web Search ──────────────────────────────────────────────────────
		INCLUDE_WEB_FEATURES: true,
		INCLUDE_SEARCH_QUERIES: true,
		INCLUDE_SEARCH_RESULTS: false, // Off by default (noisy raw data)
		COLLAPSIBLE_SEARCH_RESULTS: true,
		INCLUDE_SOURCES: true, // Inline citation markers
		INCLUDE_SOURCES_LIST: true, // Bibliography at end of message
		COLLAPSIBLE_SOURCES_LIST: true,

		// ─── Metadata ────────────────────────────────────────────────────────
		INCLUDE_MODEL_INFO: true,
		INCLUDE_THINKING_DURATION: false,
		INCLUDE_TIMESTAMPS: false,
		INCLUDE_MESSAGE_IDS: false,

		// ─── Header & Formatting ─────────────────────────────────────────────
		INCLUDE_HEADER: true,
		INCLUDE_ACTIVE_LEAF_INFO: true,
		INCLUDE_TURN_NUMBERS: true,
		COLLAPSIBLE_MESSAGES: false,

		// ─── Branching ───────────────────────────────────────────────────────
		EXPORT_ALL_REGENERATIONS: false,

		// ─── File Naming ─────────────────────────────────────────────────────
		FILENAME_MAX_LEN: 80,

		// ─── UI (Button) ─────────────────────────────────────────────────────
		BUTTON_SIZE: 50,
		BUTTON_COLOR_READY: "#22c55e",
		BUTTON_COLOR_LOADING: "#f59e0b",
		BUTTON_COLOR_ERROR: "#ef4444",
		Z_INDEX: 2147483647,
		POSITION_STORAGE_PREFIX: "chat_export_pos_",
		SETTINGS_STORAGE_PREFIX: "chat_export_config_",
		HINT_DISMISSED_KEY: "chat_export_hint_dismissed",
		DEBUG: true,
	};

	// Debug logging gate:
	// - When DEBUG is false, silence log/warn/info/debug (keep error enabled).
	// - This avoids noisy console output for normal users while preserving error visibility.
	const console = (() => {
		const real =
			typeof window !== "undefined" && window.console ? window.console : null;
		const noop = () => {};
		if (!real)
			return { log: noop, warn: noop, info: noop, debug: noop, error: noop };
		if (CONFIG.DEBUG) return real;
		return {
			log: noop,
			warn: noop,
			info: noop,
			debug: noop,
			error: typeof real.error === "function" ? real.error.bind(real) : noop,
		};
	})();

	// ───────────────────────────────────────────────────────────────────────────
	// PROVIDER FLAG APPLICABILITY
	// ───────────────────────────────────────────────────────────────────────────
	// Maps CONFIG flags to providers for the settings panel UI.
	// Order determines display order in settings menu.
	// See PROVIDER SUPPORT MATRIX in CONFIG section for capability details.
	//
	const PROVIDER_FLAGS = {
		Claude: [
			"INCLUDE_USER_MESSAGES",
			"INCLUDE_ASSISTANT_MESSAGES",
			"INCLUDE_TURN_NUMBERS",
			"COLLAPSIBLE_MESSAGES",
			"INCLUDE_CODE_BLOCKS",
			"COLLAPSIBLE_CODE_BLOCKS",
			"INCLUDE_WIDGETS",
			"WIDGET_MD_RELATIVE_PATH",
			"WIDGET_MD_BASE64",
			"WIDGET_MD_DATAURI_TEXT",
			"WIDGET_HTML_SVG_RAW",
			"WIDGET_HTML_IMG_BASE64",
			"WIDGET_HTML_IMG_DATAURI",
			"WIDGET_CLICKABLE_LINK",
			"COLLAPSIBLE_WIDGETS",
			"INCLUDE_TOOL_CALLS",
			"COLLAPSIBLE_TOOL_CALLS",
			"INCLUDE_THINKING",
			"COLLAPSIBLE_THINKING",
			"INCLUDE_ATTACHMENTS",
			"CLAUDE_EMBED_FILES_V2_CONTENT",
			"COLLAPSIBLE_ATTACHMENTS",
			"INCLUDE_ARTIFACTS",
			"COLLAPSIBLE_ARTIFACTS",
			"INCLUDE_WEB_FEATURES",
			"INCLUDE_SEARCH_QUERIES",
			"INCLUDE_SEARCH_RESULTS",
			"COLLAPSIBLE_SEARCH_RESULTS",
			"INCLUDE_SOURCES",
			"INCLUDE_SOURCES_LIST",
			"COLLAPSIBLE_SOURCES_LIST",
			"INCLUDE_MODEL_INFO",
			"INCLUDE_TIMESTAMPS",
			"INCLUDE_MESSAGE_IDS",
			"INCLUDE_HEADER",
			"INCLUDE_ACTIVE_LEAF_INFO",
			"EXPORT_ALL_REGENERATIONS",
		],
		Grok: [
			"INCLUDE_USER_MESSAGES",
			"INCLUDE_ASSISTANT_MESSAGES",
			"INCLUDE_TURN_NUMBERS",
			"COLLAPSIBLE_MESSAGES",
			"INCLUDE_CODE_BLOCKS",
			"COLLAPSIBLE_CODE_BLOCKS",
			"INCLUDE_ATTACHMENTS",
			"COLLAPSIBLE_ATTACHMENTS",
			"INCLUDE_WEB_FEATURES",
			"INCLUDE_SOURCES_LIST",
			"COLLAPSIBLE_SOURCES_LIST",
			"INCLUDE_MODEL_INFO",
			"INCLUDE_THINKING_DURATION",
			"INCLUDE_TIMESTAMPS",
			"INCLUDE_MESSAGE_IDS",
			"INCLUDE_HEADER",
			"INCLUDE_ACTIVE_LEAF_INFO",
			"EXPORT_ALL_REGENERATIONS",
		],
		Arena: [
			"INCLUDE_USER_MESSAGES",
			"INCLUDE_ASSISTANT_MESSAGES",
			"INCLUDE_TURN_NUMBERS",
			"COLLAPSIBLE_MESSAGES",
			"INCLUDE_CODE_BLOCKS",
			"COLLAPSIBLE_CODE_BLOCKS",
			"INCLUDE_IMAGES",
			"IMAGE_DOWNLOAD_FILES",
			"IMAGE_MD_RELATIVE_PATH",
			"IMAGE_MD_BASE64",
			"IMAGE_MD_REMOTE_URL",
			"IMAGE_HTML_IMG_BASE64",
			"IMAGE_HTML_IMG_REMOTE",
			"IMAGE_CLICKABLE_WEB_LINK",
			"IMAGE_CLICKABLE_FILE_LINK",
			"COLLAPSIBLE_IMAGES",
			"INCLUDE_THINKING",
			"COLLAPSIBLE_THINKING",
			"INCLUDE_WEB_FEATURES",
			"INCLUDE_SOURCES",
			"INCLUDE_SOURCES_LIST",
			"COLLAPSIBLE_SOURCES_LIST",
			"INCLUDE_MODEL_INFO",
			"INCLUDE_TIMESTAMPS",
			"INCLUDE_MESSAGE_IDS",
			"INCLUDE_HEADER",
		],
		ChatGPT: [
			"INCLUDE_USER_MESSAGES",
			"INCLUDE_ASSISTANT_MESSAGES",
			"INCLUDE_TURN_NUMBERS",
			"COLLAPSIBLE_MESSAGES",
			"INCLUDE_CODE_BLOCKS",
			"COLLAPSIBLE_CODE_BLOCKS",
			"INCLUDE_IMAGES",
			"IMAGE_DOWNLOAD_FILES",
			"IMAGE_MD_RELATIVE_PATH",
			"IMAGE_MD_BASE64",
			"IMAGE_MD_REMOTE_URL",
			"IMAGE_HTML_IMG_BASE64",
			"IMAGE_HTML_IMG_REMOTE",
			"IMAGE_CLICKABLE_WEB_LINK",
			"IMAGE_CLICKABLE_FILE_LINK",
			"COLLAPSIBLE_IMAGES",
			"INCLUDE_TOOL_CALLS",
			"COLLAPSIBLE_TOOL_CALLS",
			"INCLUDE_WEB_FEATURES",
			"INCLUDE_SEARCH_QUERIES",
			"INCLUDE_SEARCH_RESULTS",
			"COLLAPSIBLE_SEARCH_RESULTS",
			"INCLUDE_SOURCES",
			"INCLUDE_SOURCES_LIST",
			"COLLAPSIBLE_SOURCES_LIST",
			"INCLUDE_MODEL_INFO",
			"INCLUDE_TIMESTAMPS",
			"INCLUDE_MESSAGE_IDS",
			"INCLUDE_HEADER",
			"INCLUDE_ACTIVE_LEAF_INFO",
			"EXPORT_ALL_REGENERATIONS",
		],
	};

	// Human-readable labels and grouping for settings UI
	const FLAG_METADATA = {
		// Group: Messages
		INCLUDE_USER_MESSAGES: {
			label: "Include User Messages",
			group: "Messages",
		},
		INCLUDE_ASSISTANT_MESSAGES: {
			label: "Include Assistant Messages",
			group: "Messages",
		},
		INCLUDE_TURN_NUMBERS: {
			label: "Include Turn Numbers",
			group: "Messages",
			tooltip:
				"Add sequential numbers to message headers: [1] USER, [2] ASSISTANT, etc.",
		},
		COLLAPSIBLE_MESSAGES: {
			label: "Collapsible Messages",
			group: "Messages",
			tooltip: "Wrap each message turn in a collapsible section.",
		},

		// Group: Thinking
		INCLUDE_THINKING: {
			label: "Include Thinking/Reasoning",
			group: "Thinking",
		},
		COLLAPSIBLE_THINKING: {
			label: "Collapsible Thinking",
			group: "Thinking",
			indent: true,
		},
		INCLUDE_THINKING_DURATION: {
			label: "Show Thinking Duration",
			group: "Thinking",
		},

		// Group: Attachments
		INCLUDE_ATTACHMENTS: { label: "Include Attachments", group: "Attachments" },
		CLAUDE_EMBED_FILES_V2_CONTENT: {
			label: { Claude: "Embed Uploaded File Contents (files_v2)" },
			group: "Attachments",
			indent: true,
			tooltip: {
				Claude:
					"Downloads and embeds content of Claude uploaded files (files_v2) via wiggle/download-file.\nMay increase export time and file size.\nIf disabled, exports only metadata (name/path/uuid).",
			},
		},
		COLLAPSIBLE_ATTACHMENTS: {
			label: "Collapsible Attachments",
			group: "Attachments",
			indent: true,
		},

		// Group: Artifacts
		INCLUDE_ARTIFACTS: { label: "Include Artifacts", group: "Artifacts" },
		COLLAPSIBLE_ARTIFACTS: {
			label: "Collapsible Artifacts",
			group: "Artifacts",
			indent: true,
		},

		// Group: Widgets
		INCLUDE_WIDGETS: {
			label: "Include Widgets",
			group: "Widgets",
			tooltip:
				'Export Claude visualize widgets (show_widget).\nRequires clicking "Download file" on each widget before or during export to capture the rendered SVG.',
		},
		// ─── Markdown Inline ───
		WIDGET_MD_RELATIVE_PATH: {
			label: "![](file.svg) relative path",
			group: "Widgets",
			subsection: "Markdown Inline",
			indent: true,
			tooltip:
				"Reference widget SVG via relative filename in markdown.\nRequires you to manually download the SVG via Claude's 'Download file' button and place it alongside the markdown.",
		},
		WIDGET_MD_BASE64: {
			label: "![](data:base64,...)",
			group: "Widgets",
			subsection: "Markdown Inline",
			indent: true,
			tooltip:
				"Embed widget SVG as base64 data URI in markdown image syntax.\nMost portable but increases file size significantly.",
		},
		WIDGET_MD_DATAURI_TEXT: {
			label: "![](data:utf-8,<svg>...)",
			group: "Widgets",
			subsection: "Markdown Inline",
			indent: true,
			tooltip:
				"Embed widget SVG as URL-encoded text data URI.\nReadable in source but larger than base64.",
		},
		// ─── HTML Inline ───
		WIDGET_HTML_SVG_RAW: {
			label: "<svg>...</svg> raw",
			group: "Widgets",
			subsection: "HTML Inline",
			indent: true,
			tooltip:
				"Embed raw SVG element directly in markdown.\nRenders as interactive SVG in most markdown viewers.",
		},
		WIDGET_HTML_IMG_BASE64: {
			label: '<img src="data:base64,...">',
			group: "Widgets",
			subsection: "HTML Inline",
			indent: true,
			tooltip:
				"Embed widget as HTML img tag with base64 data URI.\nWidely compatible.",
		},
		WIDGET_HTML_IMG_DATAURI: {
			label: '<img src="data:utf-8,...">',
			group: "Widgets",
			subsection: "HTML Inline",
			indent: true,
			tooltip:
				"Embed widget as HTML img tag with URL-encoded SVG.\nReadable in source but larger.",
		},
		// ─── Link ───
		WIDGET_CLICKABLE_LINK: {
			label: "Clickable link",
			group: "Widgets",
			subsection: "Link",
			indent: true,
			tooltip:
				"Add an explicit clickable markdown link to open the widget SVG file.",
		},
		// ─── Wrapper ───
		COLLAPSIBLE_WIDGETS: {
			label: "Collapsible Widgets",
			group: "Widgets",
			subsection: "Wrapper",
			indent: true,
			tooltip: "Wrap widget output in a collapsible section.",
		},
		// Group: Code
		INCLUDE_CODE_BLOCKS: { label: "Include Code Blocks", group: "Code" },
		COLLAPSIBLE_CODE_BLOCKS: {
			label: "Collapsible Code Blocks",
			group: "Code",
			indent: true,
		},

		// Group: Images
		INCLUDE_IMAGES: {
			label: "Include Images",
			group: "Images",
			tooltip:
				"Master toggle for all image-related features.\nWhen off, no images are exported.\nWhen on, select which formats to include below.",
		},
		// ─── Download ───
		IMAGE_DOWNLOAD_FILES: {
			label: "Download image files",
			group: "Images",
			subsection: "Download",
			indent: true,
			tooltip: "Save images as separate files alongside the markdown.",
		},
		// ─── Markdown Inline ───
		IMAGE_MD_RELATIVE_PATH: {
			label: "![](file.ext) relative path",
			group: "Images",
			subsection: "Markdown Inline",
			indent: true,
			tooltip:
				"Embed markdown images using local filenames.\nRequires image files to be saved alongside the markdown.",
		},
		IMAGE_MD_BASE64: {
			label: "![](data:base64,...)",
			group: "Images",
			subsection: "Markdown Inline",
			indent: true,
			tooltip:
				"Embed images as base64 data URIs inside markdown.\nMost portable, but increases file size.",
		},
		IMAGE_MD_REMOTE_URL: {
			label: "![](remote URL)",
			group: "Images",
			subsection: "Markdown Inline",
			indent: true,
			tooltip:
				"Embed images using web URLs.\nMay expire or require active auth/session.",
		},
		// ─── HTML Inline ───
		IMAGE_HTML_IMG_BASE64: {
			label: '<img src="data:base64,...">',
			group: "Images",
			subsection: "HTML Inline",
			indent: true,
			tooltip:
				"Embed images as HTML img tags with base64 data URIs.\nWidely compatible.",
		},
		IMAGE_HTML_IMG_REMOTE: {
			label: '<img src="remote URL">',
			group: "Images",
			subsection: "HTML Inline",
			indent: true,
			tooltip:
				"Embed images as HTML img tags with remote URLs.\nMay expire or require active auth/session.",
		},
		// ─── Link ───
		IMAGE_CLICKABLE_WEB_LINK: {
			label: "Clickable link (web)",
			group: "Images",
			subsection: "Link",
			indent: true,
			tooltip:
				"Add a clickable link to open the image via its web URL.\nAlways available when images are included.",
		},
		IMAGE_CLICKABLE_FILE_LINK: {
			label: "Clickable link (file)",
			group: "Images",
			subsection: "Link",
			indent: true,
			tooltip:
				"Add a clickable link to the downloaded image file.\nWorks offline. Requires 'Download image files' or '![](file.ext) relative path' to be enabled.",
		},
		// ─── Wrapper ───
		COLLAPSIBLE_IMAGES: {
			label: "Collapsible Images",
			group: "Images",
			subsection: "Wrapper",
			indent: true,
			tooltip: "Wrap image output in a collapsible section.",
		},

		// Group: Tools
		INCLUDE_TOOL_CALLS: {
			label: "Include Tool Calls",
			group: "Tools",
			tooltip:
				"Export tool executions/results (e.g., Claude files, ChatGPT code interpreter).",
		},
		COLLAPSIBLE_TOOL_CALLS: {
			label: "Collapsible Tool Calls",
			group: "Tools",
			indent: true,
			tooltip: "Wrap tool input/output in a collapsible <details> section.",
		},

		// Group: Web Search
		INCLUDE_WEB_FEATURES: {
			label: "Include Web Features",
			group: "Web Search",
			subsection: "",
			tooltip:
				"Master toggle for all web/search-related features.\nWhen off, no search queries, results, or sources are exported.\nWhen on, select which features to include below.",
		},
		// Ordered by Execution Flow: Queries → Results → Inline → List
		INCLUDE_SEARCH_QUERIES: {
			label: "Include Search Queries",
			group: "Web Search",
			subsection: "Queries",
			indent: true,
			tooltip:
				'Show the search terms sent to the search engine.\nAppears as: 🔍 Searching: "query"',
		},
		INCLUDE_SEARCH_RESULTS: {
			label: "Include Search Results",
			group: "Web Search",
			subsection: "Results",
			indent: true,
			tooltip:
				"Show the raw list of URLs returned by the search engine.\nThis is the data the AI received before writing its answer.\n(Often noisy; disabled by default)",
		},
		COLLAPSIBLE_SEARCH_RESULTS: {
			label: "Collapsible Search Results",
			group: "Web Search",
			subsection: "Results",
			indent: true,
			extraIndent: true,
			tooltip:
				"Wrap the raw search results in a collapsible <details> section.",
		},
		INCLUDE_SOURCES: {
			label: {
				ChatGPT: "Include Inline Citations",
				Claude: "Include Inline Citations",
				Arena: "Include Inline Citations",
			},
			group: "Web Search",
			subsection: "Citations",
			indent: true,
			tooltip: {
				ChatGPT:
					"Insert linked numeric superscripts from content_references metadata and clean proprietary citation markers.",
				Claude:
					"Insert superscript citation markers into the message text.\nFormat: [[Title]](url) at each citation position.",
				Arena:
					"Insert numbered superscript markers into the message text.\nFormat: [1], [2], etc. linking to the source URL.",
			},
		},
		INCLUDE_SOURCES_LIST: {
			label: "Include Sources List",
			group: "Web Search",
			subsection: "Sources List",
			indent: true,
			tooltip: {
				ChatGPT:
					"Append a numbered bibliography at the end of the message.\nIncludes sources extracted from content_references.",
				Claude:
					"Append a numbered bibliography at the end of the message.\nLists all cited sources for easy reference.",
				Arena:
					"Append a numbered bibliography at the end of the message.\nLists all cited sources for easy reference.",
				Grok: "Append the list of web sources at the end of the message.\n(Grok does not support inline citations.)",
			},
		},
		COLLAPSIBLE_SOURCES_LIST: {
			label: "Collapsible Sources List",
			group: "Web Search",
			subsection: "Sources List",
			indent: true,
			extraIndent: true,
			tooltip:
				"Wrap the sources list in a collapsible <details> section.\nKeeps the export cleaner when there are many sources.",
		},

		// Group: Metadata
		INCLUDE_MODEL_INFO: { label: "Show Model Names", group: "Metadata" },
		INCLUDE_TIMESTAMPS: { label: "Show Timestamps", group: "Metadata" },
		INCLUDE_MESSAGE_IDS: { label: "Show Message IDs", group: "Metadata" },

		// Group: Header
		INCLUDE_HEADER: { label: "Include Header", group: "Header" },
		INCLUDE_ACTIVE_LEAF_INFO: {
			label: "Show Active Leaf/Node/Response ID",
			group: "Header",
			indent: true,
		},

		// Group: Branching
		EXPORT_ALL_REGENERATIONS: {
			label: "Export All Regenerations",
			group: "Branching",
			tooltip:
				"• Enabled: export ALL messages chronologically, including regenerated responses\n• Disabled: export only the currently selected conversation path",
		},
	};

	// Group display order
	const FLAG_GROUP_ORDER = [
		"Messages",
		"Code",
		"Images",
		"Widgets",
		"Tools",
		"Thinking",
		"Attachments",
		"Artifacts",
		"Web Search",
		"Metadata",
		"Header",
		"Branching",
	];

	// Subsection display order (for groups with subsections)
	// Empty string "" renders flags without a subsection (e.g., INCLUDE_WIDGETS, INCLUDE_IMAGES)
	const FLAG_SUBSECTION_ORDER = {
		Images: [
			"",
			"Download",
			"Markdown Inline",
			"HTML Inline",
			"Link",
			"Wrapper",
		],
		Widgets: ["", "Markdown Inline", "HTML Inline", "Link", "Wrapper"],
		"Web Search": ["", "Queries", "Results", "Citations", "Sources List"],
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// SETTINGS STORAGE (Per-Provider)
	// ═══════════════════════════════════════════════════════════════════════════
	const Settings = {
		/**
		 * Load provider-specific settings and merge with base CONFIG.
		 * @param {string} providerName - e.g., 'Claude', 'Grok', 'Arena'
		 * @returns {object} - Merged settings object
		 */
		load(providerName) {
			if (!providerName) {
				console.log(
					"[Chat Exporter] Settings.load() called without provider, returning CONFIG",
				);
				return { ...CONFIG };
			}

			try {
				const key = CONFIG.SETTINGS_STORAGE_PREFIX + providerName;
				const saved = GM_getValue(key, null);
				console.log(
					"[Chat Exporter] Settings.load() for",
					providerName,
					"- raw storage:",
					saved,
				);

				if (saved) {
					const overrides =
						typeof saved === "string" ? JSON.parse(saved) : saved;
					const merged = { ...CONFIG, ...overrides };

					console.log(
						"[Chat Exporter] Settings.load() merged result - INCLUDE_USER_MESSAGES:",
						merged.INCLUDE_USER_MESSAGES,
						"INCLUDE_ASSISTANT_MESSAGES:",
						merged.INCLUDE_ASSISTANT_MESSAGES,
					);
					return merged;
				}
			} catch (e) {
				console.warn("[Chat Exporter] Failed to load settings:", e);
			}

			console.log(
				"[Chat Exporter] Settings.load() no overrides found, returning CONFIG defaults",
			);
			return { ...CONFIG };
		},

		/**
		 * Save provider-specific setting override.
		 * @param {string} providerName
		 * @param {string} flagName
		 * @param {boolean} value
		 */
		save(providerName, flagName, value) {
			if (!providerName) return;

			try {
				const key = CONFIG.SETTINGS_STORAGE_PREFIX + providerName;
				let overrides = {};

				const saved = GM_getValue(key, null);
				if (saved) {
					overrides = typeof saved === "string" ? JSON.parse(saved) : saved;
				}

				overrides[flagName] = value;
				GM_setValue(key, overrides);
				console.log(
					"[Chat Exporter] Settings.save() -",
					flagName,
					"=",
					value,
					"for",
					providerName,
				);
				console.log(
					"[Chat Exporter] Settings.save() - full overrides now:",
					overrides,
				);
			} catch (e) {
				console.warn("[Chat Exporter] Failed to save settings:", e);
			}
		},

		/**
		 * Get current effective value of a flag for a provider.
		 * @param {string} providerName
		 * @param {string} flagName
		 * @returns {boolean}
		 */
		get(providerName, flagName) {
			const settings = this.load(providerName);
			return settings[flagName];
		},

		/**
		 * Reset all settings for a provider to defaults.
		 * @param {string} providerName
		 */
		reset(providerName) {
			if (!providerName) return;
			const key = CONFIG.SETTINGS_STORAGE_PREFIX + providerName;
			GM_deleteValue(key);
			console.log(
				"[Chat Exporter] Settings.reset() - cleared all overrides for",
				providerName,
			);
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// UTILITY FUNCTIONS
	// ═══════════════════════════════════════════════════════════════════════════
	const Utils = {
		/**
		 * Sanitize text for use in markdown (strips markdown special chars).
		 * @param {string} s - Raw text
		 * @param {string} fallback - Fallback if result is empty
		 * @returns {string} - Sanitized text safe for markdown display
		 */
		sanitize(s, fallback = "Untitled") {
			if (!s) return fallback;
			return (
				s
					.replace(/[\r\n]+/g, " ")
					.replace(/[#`*[\]:/\\?*|"<>;]/g, "")
					.trim() || fallback
			);
		},

		/**
		 * Sanitize for filename (applies sanitize + length limit + underscore spaces).
		 * @param {string} s - Raw text
		 * @param {string} fallback - Fallback if result is empty
		 * @returns {string} - Safe filename (without extension)
		 */
		sanitizeFilename(s, fallback = "Export") {
			const clean = this.sanitize(s, fallback);
			return clean.substring(0, CONFIG.FILENAME_MAX_LEN).replace(/\s+/g, "_");
		},

		/**
		 * Sanitize a name for filesystem safety (removes invalid chars and control chars).
		 * Handles Windows/Unix forbidden characters and control characters (0x00-0x1f).
		 * @param {string} name - Raw filename
		 * @returns {string} - Filesystem-safe filename
		 */
		sanitizeFilesystemName(name) {
			// biome-ignore lint/suspicious/noControlCharactersInRegex: intentional control char removal for filesystem safety
			return String(name ?? "").replace(/[<>:"/\\|?*\x00-\x1f]/g, "_");
		},

		/**
		 * Encode SVG text as base64 data URI.
		 * @param {string} svgText - Raw SVG markup
		 * @returns {string} - data:image/svg+xml;base64,... URI
		 */
		encodeSvgBase64(svgText) {
			const b64 = btoa(unescape(encodeURIComponent(svgText)));
			return `data:image/svg+xml;base64,${b64}`;
		},

		/**
		 * Encode SVG text as URL-encoded data URI.
		 * @param {string} svgText - Raw SVG markup
		 * @returns {string} - data:image/svg+xml;charset=utf-8,... URI
		 */
		encodeSvgDataUri(svgText) {
			const encoded = encodeURIComponent(svgText);
			return `data:image/svg+xml;charset=utf-8,${encoded}`;
		},

		escapeHtml(s) {
			return String(s ?? "")
				.replace(/&/g, "&amp;")
				.replace(/</g, "&lt;")
				.replace(/>/g, "&gt;")
				.replace(/"/g, "&quot;")
				.replace(/'/g, "&#39;");
		},

		/**
		 * Create a "safe" fenced code block that cannot be prematurely closed by
		 * backticks inside the content (e.g. when a markdown file contains ```).
		 * We choose a fence length of (max backtick run in content + 1).
		 */
		makeCodeFence(content, lang = "") {
			const text = String(content ?? "").replace(/\r\n/g, "\n");
			const runs = text.match(/`+/g) || [];
			let maxRun = 0;
			for (const r of runs) {
				if (r.length > maxRun) maxRun = r.length;
			}

			const fenceLen = Math.max(3, maxRun + 1);
			const fence = "`".repeat(fenceLen);
			const info = lang ? String(lang) : "";

			const body = text.endsWith("\n") ? text : `${text}\n`;
			return `${fence}${info}\n${body}${fence}`;
		},

		/**
		 * Format a thinking/reasoning block as markdown.
		 * Used by Claude (thinking blocks) and Arena (reasoning field).
		 * @param {string} thinking - Raw thinking/reasoning text
		 * @returns {string} - Formatted markdown string
		 */
		formatThinkingBlock(thinking, cfg = null) {
			if (!thinking) return "";
			const settings = cfg || CONFIG;

			const quoted = thinking.replace(/\n/g, "\n> ");

			if (settings.COLLAPSIBLE_THINKING) {
				return `<details>\n<summary><strong>💭 Thinking Process</strong></summary>\n\n> ${quoted}\n\n</details>\n\n`;
			} else {
				return `> **💭 Thinking:**\n> \n> ${quoted}\n\n`;
			}
		},

		/**
		 * Process code blocks in text based on settings.
		 * If INCLUDE_CODE_BLOCKS is false, removes all code blocks.
		 * If COLLAPSIBLE_CODE_BLOCKS is true, wraps them in <details>.
		 * Otherwise, leaves them as-is.
		 * @param {string} text - Markdown text with code blocks
		 * @param {object} cfg - Settings object
		 * @returns {string} - Processed text
		 */
		processCodeBlocks(text, cfg = null) {
			if (!text) return text;
			const settings = cfg || CONFIG;

			// If code blocks disabled, strip them entirely
			if (!settings.INCLUDE_CODE_BLOCKS) {
				return this.stripCodeBlocks(text);
			}

			// If not collapsible, return as-is
			if (!settings.COLLAPSIBLE_CODE_BLOCKS) {
				return text;
			}

			// Wrap in collapsible
			return this.wrapCodeBlocksCollapsible(text);
		},

		/**
		 * Strip all fenced code blocks from text
		 * @param {string} text - Markdown text with code blocks
		 * @returns {string} - Text with code blocks removed
		 */
		stripCodeBlocks(text) {
			if (!text) return text;

			const normalized = String(text).replace(/\r\n/g, "\n");
			const lines = normalized.split("\n");

			const out = [];
			let inFence = false;
			let fenceLen = 0;

			for (const line of lines) {
				const m = line.match(/^(`{3,})(.*)$/);
				if (m) {
					const ticks = m[1];
					if (!inFence) {
						inFence = true;
						fenceLen = ticks.length;
					} else if (ticks.length >= fenceLen) {
						inFence = false;
						fenceLen = 0;
					}
					continue;
				}

				if (!inFence) {
					out.push(line);
				}
			}

			return out.join("\n");
		},

		/**
		 * Wrap code blocks (```...```) in collapsible <details> sections
		 * @param {string} text - Markdown text with code blocks
		 * @returns {string} - Text with code blocks wrapped in <details>
		 */
		wrapCodeBlocksCollapsible(text) {
			if (!text) return text;

			const normalized = String(text).replace(/\r\n/g, "\n");

			// State machine to support BOTH:
			// - complete fenced blocks
			// - incomplete blocks (e.g., streaming/partial responses without a closing fence)
			// Also supports fences longer than 3 backticks (e.g. ````) and won't close early on ```
			const lines = normalized.split("\n");

			const out = [];
			let inFence = false;
			let fenceLen = 0;
			let fenceLang = "";
			let buf = [];

			const flushFence = (isTruncated) => {
				// Use first token only as fence info string (best practice for Markdown code fences)
				const safeLang = (fenceLang || "").trim().split(/\s+/)[0];
				const langLabel = safeLang ? ` (${safeLang})` : "";
				const lineCount = buf.length;

				const summary = `💻 Code Block${langLabel}${isTruncated ? " — truncated" : ""} — ${lineCount} lines`;
				const fenced = this.makeCodeFence(buf.join("\n"), safeLang);

				out.push(
					`<details>\n` +
						`<summary><strong>${this.escapeHtml(summary)}</strong></summary>\n\n` +
						`${fenced}\n\n` +
						`</details>`,
				);

				buf = [];
				fenceLen = 0;
				fenceLang = "";
			};

			for (const line of lines) {
				// Any fence of 3+ backticks at start of line
				const m = line.match(/^(`{3,})(.*)$/);
				if (m) {
					const ticks = m[1];
					const rest = m[2] || "";

					if (!inFence) {
						// Opening fence
						inFence = true;
						fenceLen = ticks.length;
						fenceLang = rest.trim();
						buf = [];
					} else {
						// Closing fence: must be at least as long as opening fence
						if (ticks.length >= fenceLen) {
							inFence = false;
							flushFence(false);
						} else {
							// Treat as content if it's a shorter fence inside a longer-fenced block
							buf.push(line);
						}
					}
					continue;
				}

				if (inFence) {
					buf.push(line);
				} else {
					out.push(line);
				}
			}

			// If message ended mid-fence (common with Grok partial responses), close it for export
			if (inFence) {
				flushFence(true);
			}

			return out.join("\n");
		},

		parseResponseHeaders(rawHeaders) {
			const headers = {};
			const raw = String(rawHeaders || "");
			raw.split(/\r?\n/).forEach((line) => {
				const idx = line.indexOf(":");
				if (idx <= 0) return;
				const key = line.slice(0, idx).trim().toLowerCase();
				const value = line.slice(idx + 1).trim();
				if (!key) return;
				headers[key] = value;
			});
			return headers;
		},

		inferExtensionFromMime(mime) {
			const m = String(mime || "").toLowerCase();
			if (m.includes("image/png")) return "png";
			if (m.includes("image/jpeg") || m.includes("image/jpg")) return "jpg";
			if (m.includes("image/webp")) return "webp";
			if (m.includes("image/gif")) return "gif";
			if (m.includes("image/svg+xml")) return "svg";
			if (m.includes("image/avif")) return "avif";
			return "img";
		},

		parseFilenameFromDisposition(contentDisposition) {
			const cd = String(contentDisposition || "");
			if (!cd) return "";

			// RFC 5987: filename*=UTF-8''...
			const starMatch = cd.match(/filename\*\s*=\s*([^;]+)/i);
			if (starMatch?.[1]) {
				const raw = starMatch[1].trim().replace(/^["']|["']$/g, "");
				const encPart = raw.split("''").pop() || raw;
				try {
					return decodeURIComponent(encPart);
				} catch {
					return encPart;
				}
			}

			const m = cd.match(/filename\s*=\s*([^;]+)/i);
			if (m?.[1]) {
				return m[1].trim().replace(/^["']|["']$/g, "");
			}
			return "";
		},

		fetchImageData(url) {
			return new Promise((resolve) => {
				if (!url) {
					resolve(null);
					return;
				}
				try {
					GM_xmlhttpRequest({
						method: "GET",
						url,
						responseType: "blob",
						timeout: 60000,
						onload: (response) => {
							if (response.status !== 200) {
								resolve({
									ok: false,
									status: response.status,
									error: `HTTP ${response.status}`,
								});
								return;
							}

							const blob = response.response;
							const headers = this.parseResponseHeaders(
								response.responseHeaders,
							);
							const contentType = headers["content-type"] || blob?.type || "";
							const fileName = this.parseFilenameFromDisposition(
								headers["content-disposition"],
							);

							const reader = new FileReader();
							reader.onload = () => {
								resolve({
									ok: true,
									status: response.status,
									blob,
									dataUri: reader.result,
									headers,
									contentType,
									fileName,
								});
							};
							reader.onerror = () => {
								resolve({
									ok: false,
									status: response.status,
									error: "FileReader failed",
								});
							};
							reader.readAsDataURL(blob);
						},
						onerror: (err) => {
							resolve({
								ok: false,
								status: 0,
								error: err?.error ? String(err.error) : "Network error",
							});
						},
						ontimeout: () => {
							resolve({
								ok: false,
								status: 0,
								error: "Timeout",
							});
						},
					});
				} catch (e) {
					resolve({
						ok: false,
						status: 0,
						error: e?.message || "Exception",
					});
				}
			});
		},
	};

	const ImageOptions = {
		hasAny(cfg = CONFIG) {
			// Master toggle must be on first
			if (!cfg.INCLUDE_IMAGES) return false;
			return !!(
				cfg.IMAGE_DOWNLOAD_FILES ||
				cfg.IMAGE_MD_RELATIVE_PATH ||
				cfg.IMAGE_MD_BASE64 ||
				cfg.IMAGE_MD_REMOTE_URL ||
				cfg.IMAGE_HTML_IMG_BASE64 ||
				cfg.IMAGE_HTML_IMG_REMOTE ||
				cfg.IMAGE_CLICKABLE_WEB_LINK ||
				cfg.IMAGE_CLICKABLE_FILE_LINK
			);
		},
		needsDownload(cfg = CONFIG) {
			// Master toggle must be on first
			if (!cfg.INCLUDE_IMAGES) return false;
			return !!(
				cfg.IMAGE_DOWNLOAD_FILES ||
				cfg.IMAGE_MD_RELATIVE_PATH ||
				cfg.IMAGE_MD_BASE64 ||
				cfg.IMAGE_HTML_IMG_BASE64
			);
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// PROVIDER: CLAUDE
	// ═══════════════════════════════════════════════════════════════════════════
	const ClaudeProvider = {
		name: "Claude",
		hostPattern: /claude\.ai/,
		orgId: null,

		// ═════════════════════════════════════════════════════════════════════
		// WIDGET CACHE (always-on MCP listener)
		// ═════════════════════════════════════════════════════════════════════
		// Claude widgets render inside a cross-origin iframe. The rendered SVG
		// is emitted via MCP `ui/download-file` when the user clicks "Download file"
		// on the widget. This listener runs at all times, capturing SVGs into
		// an in-memory cache keyed by widget title.
		WidgetCache: {
			/** @type {Map<string, {svgText: string, fileName: string, capturedAt: number}>} */
			_cache: new Map(),
			_installed: false,

			/**
			 * Install the always-on message listener.
			 * Safe to call multiple times (idempotent).
			 */
			install() {
				if (this._installed) return;
				this._installed = true;

				window.addEventListener(
					"message",
					(event) => {
						try {
							const data = event.data;
							if (!data || typeof data !== "object") return;
							if (data.jsonrpc !== "2.0") return;
							if (data.method !== "ui/download-file") return;

							const contents = data.params?.contents;
							if (!Array.isArray(contents) || contents.length === 0) return;
							const resource = contents[0]?.resource;
							if (!resource) return;
							if (resource.mimeType !== "image/svg+xml") return;

							const svgText = resource.text;
							if (!svgText || typeof svgText !== "string") return;

							const uri = resource.uri || "";
							// Extract title from URI: "file:///bolt_gapping_spring_model.svg"
							const fileName = uri.replace(/^file:\/\/\//, "");
							const title = fileName.replace(/\.svg$/i, "");

							if (!title) return;

							this._cache.set(title, {
								svgText,
								fileName: fileName.endsWith(".svg") ? fileName : `${title}.svg`,
								capturedAt: Date.now(),
							});
							console.log(
								`[Chat Exporter] Widget SVG captured: "${title}" (${svgText.length} chars)`,
							);
							// Notify any open capture dialog
							try {
								window.dispatchEvent(
									new CustomEvent("widget-cache-update", { detail: { title } }),
								);
							} catch (_) {
								/* ignore */
							}
						} catch (_e) {
							// Silently ignore malformed messages
						}
					},
					true,
				);
				console.log(
					"[Chat Exporter] ClaudeProvider.WidgetCache listener installed",
				);
			},

			get(title) {
				return this._cache.get(title) || null;
			},

			has(title) {
				return this._cache.has(title);
			},
		},

		// ═════════════════════════════════════════════════════════════════════
		// WIDGET CAPTURE DIALOG (shown during export when widgets are detected)
		// ═════════════════════════════════════════════════════════════════════
		WidgetCaptureDialog: {
			_overlay: null,
			_resolve: null,
			_cacheListener: null,

			/**
			 * Show a dialog listing detected widgets with capture status.
			 * Returns a Promise that resolves with a Set of selected titles, or null if cancelled.
			 * @param {string[]} widgetTitles - Titles of detected widgets
			 * @returns {Promise<Set<string>|null>}
			 */
			show(widgetTitles) {
				return new Promise((resolve) => {
					this._resolve = resolve;

					// If all widgets are already cached, skip dialog entirely
					const allCached = widgetTitles.every((t) =>
						ClaudeProvider.WidgetCache.has(t),
					);
					if (allCached) {
						resolve(new Set(widgetTitles));
						return;
					}

					this._buildAndShow(widgetTitles);
				});
			},

			_buildAndShow(widgetTitles) {
				// Non-blocking floating container (bottom-right corner)
				const overlay = document.createElement("div");
				Object.assign(overlay.style, {
					position: "fixed",
					bottom: "20px",
					right: "20px",
					zIndex: CONFIG.Z_INDEX.toString(),
					fontFamily: "system-ui, -apple-system, sans-serif",
					pointerEvents: "none", // Allow clicks through to Claude UI
				});

				// Card (re-enable pointer events for dialog interaction)
				const card = document.createElement("div");
				Object.assign(card.style, {
					background: "#1f2937",
					color: "#e5e7eb",
					borderRadius: "12px",
					padding: "20px 24px",
					boxShadow: "0 8px 24px rgba(0,0,0,0.4)",
					border: "1px solid #374151",
					pointerEvents: "auto", // Make card itself clickable
					maxWidth: "380px",
				});

				// Title
				const title = document.createElement("div");
				Object.assign(title.style, {
					fontWeight: "600",
					fontSize: "15px",
					color: "#f9fafb",
					marginBottom: "6px",
				});
				title.textContent = `🧩 ${widgetTitles.length} widget${widgetTitles.length !== 1 ? "s" : ""} detected`;
				card.appendChild(title);

				// Instructions
				const instr = document.createElement("div");
				Object.assign(instr.style, {
					fontSize: "12px",
					color: "#9ca3af",
					marginBottom: "14px",
					lineHeight: "1.5",
				});
				const capturedCount = widgetTitles.filter((t) =>
					ClaudeProvider.WidgetCache.has(t),
				).length;
				if (capturedCount === widgetTitles.length) {
					instr.innerHTML =
						"✅ All widgets already captured from your session. No re-download needed — export uses cached SVGs.";
				} else {
					instr.innerHTML =
						"Click <b>Download file</b> on each widget in Claude to capture the rendered SVG.<br>✅ = already captured (no re-download) · ⏳ = needs capture";
				}
				card.appendChild(instr);

				// Widget list
				const list = document.createElement("div");
				Object.assign(list.style, { marginBottom: "16px" });

				const rows = [];
				for (const wt of widgetTitles) {
					const row = document.createElement("label");
					Object.assign(row.style, {
						display: "flex",
						alignItems: "center",
						gap: "10px",
						padding: "6px 0",
						cursor: "pointer",
						fontSize: "13px",
					});

					const cb = document.createElement("input");
					cb.type = "checkbox";
					cb.checked = ClaudeProvider.WidgetCache.has(wt);
					Object.assign(cb.style, {
						width: "16px",
						height: "16px",
						accentColor: "#22c55e",
						flexShrink: "0",
					});

					const status = document.createElement("span");
					Object.assign(status.style, { flexShrink: "0", fontSize: "14px" });

					const label = document.createElement("span");
					Object.assign(label.style, { flex: "1", wordBreak: "break-word" });
					label.textContent = wt;

					row.appendChild(cb);
					row.appendChild(status);
					row.appendChild(label);
					list.appendChild(row);
					rows.push({ title: wt, cb, status });
				}
				card.appendChild(list);

				// Button row
				const btnRow = document.createElement("div");
				Object.assign(btnRow.style, {
					display: "flex",
					justifyContent: "space-between",
					alignItems: "center",
					gap: "10px",
					borderTop: "1px solid #374151",
					paddingTop: "14px",
				});

				const cancelBtn = document.createElement("button");
				Object.assign(cancelBtn.style, {
					background: "transparent",
					border: "1px solid #374151",
					color: "#9ca3af",
					padding: "6px 14px",
					borderRadius: "6px",
					fontSize: "12px",
					cursor: "pointer",
				});
				cancelBtn.textContent = "Cancel export";

				const exportBtn = document.createElement("button");
				Object.assign(exportBtn.style, {
					background: "#22c55e",
					border: "none",
					color: "#fff",
					padding: "6px 16px",
					borderRadius: "6px",
					fontSize: "12px",
					fontWeight: "600",
					cursor: "pointer",
				});

				btnRow.appendChild(cancelBtn);
				btnRow.appendChild(exportBtn);
				card.appendChild(btnRow);

				overlay.appendChild(card);
				document.body.appendChild(overlay);
				this._overlay = overlay;

				// Update status icons + button text
				const refresh = () => {
					for (const r of rows) {
						const captured = ClaudeProvider.WidgetCache.has(r.title);
						r.status.textContent = captured ? "✅" : "⏳";
						if (captured && !r.cb.checked) r.cb.checked = true;
					}
					const checkedCount = rows.filter((r) => r.cb.checked).length;
					exportBtn.textContent = `Export${checkedCount > 0 ? ` (${checkedCount} selected)` : ""}`;
				};
				refresh();

				// Listen for cache updates
				this._cacheListener = () => refresh();
				window.addEventListener("widget-cache-update", this._cacheListener);

				// Cancel
				cancelBtn.addEventListener("click", (e) => {
					e.stopPropagation();
					this._close();
					if (this._resolve) {
						this._resolve(null);
						this._resolve = null;
					}
				});

				// Export
				exportBtn.addEventListener("click", (e) => {
					e.stopPropagation();
					const selected = new Set();
					for (const r of rows) {
						if (r.cb.checked) selected.add(r.title);
					}
					this._close();
					if (this._resolve) {
						this._resolve(selected);
						this._resolve = null;
					}
				});
			},

			_close() {
				if (this._cacheListener) {
					window.removeEventListener(
						"widget-cache-update",
						this._cacheListener,
					);
					this._cacheListener = null;
				}
				if (this._overlay) {
					this._overlay.remove();
					this._overlay = null;
				}
			},
		},

		matches(url) {
			return this.hostPattern.test(url);
		},

		extractChatId(url) {
			const match = url.match(/\/chat\/([a-z0-9-]+)/);
			return match ? match[1] : null;
		},

		async getOrgId() {
			if (this.orgId) return this.orgId;
			const resp = await fetch("/api/organizations");
			if (!resp.ok) throw new Error("Failed to fetch Org ID");
			const orgs = await resp.json();
			if (orgs && orgs.length > 0) {
				this.orgId = orgs[0].uuid;
				return this.orgId;
			}
			throw new Error("No Organization found");
		},

		async fetchChat(chatId) {
			const orgId = await this.getOrgId();
			const url = `/api/organizations/${orgId}/chat_conversations/${chatId}?tree=True&rendering_mode=messages&render_all_tools=true&consistency=strong`;
			const resp = await fetch(url, {
				headers: {
					Accept: "application/json",
					"Content-Type": "application/json",
				},
			});
			if (!resp.ok) throw new Error(`API error: ${resp.status}`);

			const data = await resp.json();

			// Best-effort: download content for files_v2 uploads (newer Claude UI).
			// Gate this behind user settings to avoid unexpected large downloads.
			try {
				const s = Settings.load(this.name);
				if (s.INCLUDE_ATTACHMENTS && s.CLAUDE_EMBED_FILES_V2_CONTENT) {
					await this.hydrateFilesV2(chatId, data);
				}
			} catch (e) {
				console.warn("[Chat Exporter] Failed to hydrate Claude files_v2:", e);
			}

			return data;
		},

		async downloadFileByPath(chatId, filePath) {
			if (!filePath)
				return { ok: false, status: 0, contentType: "", buf: null };

			const orgId = await this.getOrgId();
			const url = `/api/organizations/${orgId}/conversations/${chatId}/wiggle/download-file?path=${encodeURIComponent(filePath)}`;

			const resp = await fetch(url, {
				method: "GET",
				credentials: "include",
				cache: "no-store",
			});

			const contentType = resp.headers.get("content-type") || "";

			if (!resp.ok) {
				return { ok: false, status: resp.status, contentType, buf: null };
			}

			const buf = await resp.arrayBuffer();
			return { ok: true, status: resp.status, contentType, buf };
		},

		async hydrateFilesV2(chatId, data) {
			const MAX_BYTES = 2000000; // 2MB cap per file (avoid giant exports)

			const messages = Array.isArray(data?.chat_messages)
				? data.chat_messages
				: [];
			for (const msg of messages) {
				const files = Array.isArray(msg?.files_v2) ? msg.files_v2 : [];
				for (const f of files) {
					if (!f || !f.path) continue;
					if (f.__fetchTried) continue;

					f.__fetchTried = true;

					const res = await this.downloadFileByPath(chatId, f.path);

					if (!res.ok || !res.buf) {
						f.__fetchError = res.status
							? `HTTP ${res.status}`
							: "Download failed";
						continue;
					}

					if (res.buf.byteLength > MAX_BYTES) {
						f.__fetchError = `File too large to embed (${res.buf.byteLength} bytes)`;
						continue;
					}

					// Claude often serves text files as application/octet-stream (DevTools shows hex view).
					// Decode as UTF-8; if it contains NULs, treat as binary and skip embedding.
					const text = new TextDecoder("utf-8").decode(new Uint8Array(res.buf));
					// biome-ignore lint/suspicious/noControlCharactersInRegex: intentional NUL byte detection for binary file check
					const nulCount = (text.match(/\u0000/g) || []).length;
					if (nulCount > 0) {
						f.__fetchError = "Binary file (not embedded)";
						continue;
					}

					f.__fetchedContent = text;
					f.__fetchedContentType = res.contentType || "";
				}
			}
		},

		generateMarkdown(data, settings = null) {
			// Use provider-specific settings if provided, otherwise fall back to CONFIG
			const cfg = settings || CONFIG;
			console.log(
				"[Chat Exporter] ClaudeProvider.generateMarkdown() using cfg.INCLUDE_USER_MESSAGES:",
				cfg.INCLUDE_USER_MESSAGES,
				"cfg.INCLUDE_ASSISTANT_MESSAGES:",
				cfg.INCLUDE_ASSISTANT_MESSAGES,
			);

			const title = Utils.sanitize(data.name, "Claude_Export");
			const activeLeaf = data?.current_leaf_message_uuid || null;

			let md = `# ${title}\n\n`;

			if (cfg.INCLUDE_HEADER) {
				md += `> **Provider:** Claude  \n`;
				md += `> **Date:** ${new Date().toLocaleString()}  \n`;
				if (cfg.INCLUDE_MODEL_INFO && data.model) {
					md += `> **Model:** ${data.model}  \n`;
				}
				md += `> **Source:** [Claude.ai](${location.href})  \n`;
				if (cfg.INCLUDE_ACTIVE_LEAF_INFO && activeLeaf) {
					md += `> **Active leaf:** \`${activeLeaf}\`  \n`;
				}
				md += `\n---\n\n`;
			}

			if (!data.chat_messages)
				return {
					content: md,
					filename: "empty.md",
					stats: { total: 0, exported: 0 },
				};

			// Claude conversations are a tree. Regenerations create siblings (same parent_message_uuid).
			// To export ONLY the currently selected path, walk parents from current_leaf_message_uuid.
			const ROOT_PARENT_UUID = "00000000-0000-4000-8000-000000000000";

			const byId = new Map();
			data.chat_messages.forEach((m) => {
				if (m?.uuid) byId.set(m.uuid, m);
			});

			let messagesToExport = data.chat_messages;

			if (cfg.EXPORT_ALL_REGENERATIONS) {
				// Export the full conversation history in chronological order.
				// This includes regenerated assistant replies (siblings) under the same parent.
				messagesToExport = (data.chat_messages || []).slice().sort((a, b) => {
					const timeOrIndex = (m) => {
						const t = m?.created_at ? new Date(m.created_at).getTime() : NaN;
						if (Number.isFinite(t)) return t;
						return typeof m?.index === "number" ? m.index : 0;
					};

					const ta = timeOrIndex(a);
					const tb = timeOrIndex(b);
					if (ta !== tb) return ta - tb;

					const ia = typeof a?.index === "number" ? a.index : 0;
					const ib = typeof b?.index === "number" ? b.index : 0;
					if (ia !== ib) return ia - ib;

					const ua = String(a?.uuid || "");
					const ub = String(b?.uuid || "");
					return ua.localeCompare(ub);
				});
			} else if (activeLeaf && byId.has(activeLeaf)) {
				const chain = [];
				const seen = new Set();
				let cur = byId.get(activeLeaf);

				while (cur?.uuid && !seen.has(cur.uuid)) {
					seen.add(cur.uuid);
					chain.push(cur);

					const parentId = cur.parent_message_uuid;
					if (!parentId || parentId === ROOT_PARENT_UUID) break;

					cur = byId.get(parentId);
					if (!cur) break;
				}

				chain.reverse();

				// Only use the chain if it looks sane (at least 1 message).
				if (chain.length > 0) {
					messagesToExport = chain;
				}
			}

			// Track artifact state across the exported path so we can reconstruct "update" versions.
			// Key: artifact input.id, Value: { content, language, title, type }
			const artifactStateById = new Map();

			let turnNumber = 0;
			let exportedCount = 0;

			messagesToExport.forEach((msg) => {
				const isHuman = msg.sender === "human";
				const role = isHuman ? "USER" : "CLAUDE";

				// Skip based on config
				if (isHuman && !cfg.INCLUDE_USER_MESSAGES) return;
				if (!isHuman && !cfg.INCLUDE_ASSISTANT_MESSAGES) return;

				turnNumber++;
				exportedCount++;

				// Build header with optional turn number
				let header = role;
				if (cfg.INCLUDE_TURN_NUMBERS) {
					header = `[${turnNumber}] ${header}`;
				}

				if (cfg.COLLAPSIBLE_MESSAGES) {
					md += `<details>\n<summary><strong>${header}</strong></summary>\n\n`;
				} else {
					md += `## ${header}\n\n`;
				}

				// Optional: show timestamp
				if (cfg.INCLUDE_TIMESTAMPS && msg.created_at) {
					md += `*${new Date(msg.created_at).toLocaleString()}*\n\n`;
				}

				// Optional: show message ID
				if (cfg.INCLUDE_MESSAGE_IDS && msg.uuid) {
					md += `\`ID: ${msg.uuid}\`\n\n`;
				}

				// 1) Attachments (Files uploaded by user)
				// IMPORTANT: attachments can contain markdown with ``` fences and <details> tags.
				// To prevent breaking the outer export structure, we always wrap attachment content
				// in a "safe" fenced code block with a longer backtick fence.
				if (cfg.INCLUDE_ATTACHMENTS && msg.attachments?.length > 0) {
					msg.attachments.forEach((att) => {
						if (att.extracted_content) {
							const name = att.file_name || "unnamed";
							const raw = String(att.extracted_content ?? "").replace(
								/\r\n/g,
								"\n",
							);

							const lower = String(name).toLowerCase();
							let lang = "";
							if (lower.endsWith(".md") || lower.endsWith(".markdown"))
								lang = "markdown";
							else if (lower.endsWith(".txt")) lang = "";
							else if (lower.endsWith(".ps1")) lang = "powershell";
							else if (lower.endsWith(".json")) lang = "json";
							else if (lower.endsWith(".yml") || lower.endsWith(".yaml"))
								lang = "yaml";
							else if (lower.endsWith(".js")) lang = "javascript";
							else if (lower.endsWith(".ts")) lang = "typescript";
							else if (lower.endsWith(".py")) lang = "python";
							else if (lower.endsWith(".bat") || lower.endsWith(".cmd"))
								lang = "batch";

							const fenced = Utils.makeCodeFence(raw, lang);

							if (cfg.COLLAPSIBLE_ATTACHMENTS) {
								md += `<details>\n<summary><strong>📎 Attached File: ${Utils.escapeHtml(name)}</strong></summary>\n\n${fenced}\n\n</details>\n\n`;
							} else {
								md += `**📎 Attached File: ${name}**\n\n${fenced}\n\n`;
							}
						}
					});
				}

				// 1b) Uploaded files (Claude newer UI): files_v2
				if (cfg.INCLUDE_ATTACHMENTS && msg.files_v2?.length > 0) {
					const inferLang = (filename) => {
						const lower = String(filename || "").toLowerCase();
						if (lower.endsWith(".md") || lower.endsWith(".markdown"))
							return "markdown";
						if (lower.endsWith(".txt")) return "";
						if (lower.endsWith(".json")) return "json";
						if (lower.endsWith(".yml") || lower.endsWith(".yaml"))
							return "yaml";
						if (
							lower.endsWith(".js") ||
							lower.endsWith(".mjs") ||
							lower.endsWith(".cjs")
						)
							return "javascript";
						if (lower.endsWith(".ts") || lower.endsWith(".tsx"))
							return "typescript";
						if (lower.endsWith(".py") || lower.endsWith(".pyw"))
							return "python";
						if (lower.endsWith(".html") || lower.endsWith(".htm"))
							return "html";
						if (lower.endsWith(".css")) return "css";
						if (lower.endsWith(".sh") || lower.endsWith(".bash")) return "bash";
						if (lower.endsWith(".ps1")) return "powershell";
						if (lower.endsWith(".bat") || lower.endsWith(".cmd"))
							return "batch";
						return "";
					};

					msg.files_v2.forEach((f) => {
						const name =
							f.file_name ||
							(f.path ? String(f.path).split("/").pop() : "") ||
							"unnamed";
						const lang = inferLang(name);

						if (f.__fetchedContent) {
							const fenced = Utils.makeCodeFence(
								String(f.__fetchedContent).replace(/\r\n/g, "\n"),
								lang,
							);
							if (cfg.COLLAPSIBLE_ATTACHMENTS) {
								md += `<details>\n<summary><strong>📎 Uploaded File: ${Utils.escapeHtml(name)}</strong></summary>\n\n${fenced}\n\n</details>\n\n`;
							} else {
								md += `**📎 Uploaded File: ${name}**\n\n${fenced}\n\n`;
							}
						} else {
							const metaLines = [];
							if (f.file_uuid) metaLines.push(`- uuid: \`${f.file_uuid}\``);
							if (f.path) metaLines.push(`- path: \`${f.path}\``);
							if (f.created_at)
								metaLines.push(
									`- created: ${new Date(f.created_at).toLocaleString()}`,
								);
							if (f.__fetchError)
								metaLines.push(`- download: ${f.__fetchError}`);

							const body = metaLines.length
								? metaLines.join("\n")
								: "*No metadata available*";

							if (cfg.COLLAPSIBLE_ATTACHMENTS) {
								md += `<details>\n<summary><strong>📎 Uploaded File: ${Utils.escapeHtml(name)}</strong></summary>\n\n${body}\n\n</details>\n\n`;
							} else {
								md += `**📎 Uploaded File: ${name}**\n\n${body}\n\n`;
							}
						}
					});
				}

				// 2) Content array (Thinking, Text, Artifacts, Web search tool results)
				if (msg.content && Array.isArray(msg.content)) {
					const pendingToolUses = new Map();

					const parseToolJsonBlock = (displayContent) => {
						try {
							if (!displayContent || displayContent.type !== "json_block")
								return null;
							const raw = displayContent.json_block;
							if (!raw) return null;
							const parsed = typeof raw === "string" ? JSON.parse(raw) : raw;
							if (!parsed || typeof parsed !== "object") return null;
							return {
								language: parsed.language || "",
								code: parsed.code || "",
								filename: parsed.filename || "",
							};
						} catch (_e) {
							return null;
						}
					};

					const renderToolIO = (
						title,
						inputLang,
						inputText,
						outputLang,
						outputText,
					) => {
						const parts = [];

						if (inputText) {
							parts.push(
								`**Input:**\n\n${Utils.makeCodeFence(inputText, inputLang)}\n`,
							);
						}
						if (outputText) {
							parts.push(
								`**Output:**\n\n${Utils.makeCodeFence(outputText, outputLang)}\n`,
							);
						}

						if (!parts.length) return;

						const body = parts.join("\n").trimEnd();

						if (cfg.COLLAPSIBLE_TOOL_CALLS) {
							md += `<details>\n<summary><strong>${Utils.escapeHtml(title)}</strong></summary>\n\n${body}\n\n</details>\n\n`;
						} else {
							md += `**${title}**\n\n${body}\n\n`;
						}
					};

					msg.content.forEach((block) => {
						if (block.type === "text") {
							let text = block.text || "";
							const citations = [];

							// Collect citations from this text block
							if (block.citations?.length) {
								const sortedCitations = [...block.citations]
									.filter((c) => typeof c.end_index === "number" && c.url)
									.sort((a, b) => b.end_index - a.end_index);

								sortedCitations.forEach((c) => {
									citations.unshift({
										title: c.title || c.url,
										url: c.url,
										source:
											c.metadata?.site_name || c.metadata?.site_domain || "",
										end_index: c.end_index,
									});
								});

								// Insert inline citation markers (if enabled)
								if (cfg.INCLUDE_WEB_FEATURES && cfg.INCLUDE_SOURCES) {
									// Insert from end to start to preserve positions
									sortedCitations.forEach((c) => {
										const pos = Math.min(c.end_index, text.length);
										const linkTitle = (c.title || "source")
											.replace(/\n/g, " ")
											.substring(0, 30);
										text =
											text.slice(0, pos) +
											`<sup>[[${linkTitle}](${c.url})]</sup>` +
											text.slice(pos);
									});
								}
							}

							// Process code blocks based on settings
							text = Utils.processCodeBlocks(text, cfg);

							md += `${text}\n\n`;

							// Add sources list section after this text block (if enabled)
							if (cfg.INCLUDE_SOURCES_LIST && citations.length) {
								if (cfg.COLLAPSIBLE_SOURCES_LIST) {
									md += `<details>\n<summary><strong>📚 Sources (${citations.length})</strong></summary>\n\n`;
									citations.forEach((c, idx) => {
										const t = (c.title || c.url).replace(/\n/g, " ").trim();
										const s = c.source ? ` — ${c.source}` : "";
										md += `${idx + 1}. [${t}](${c.url})${s}\n`;
									});
									md += `\n</details>\n\n`;
								} else {
									md += `**📚 Sources (${citations.length}):**\n\n`;
									citations.forEach((c, idx) => {
										const t = (c.title || c.url).replace(/\n/g, " ").trim();
										const s = c.source ? ` — ${c.source}` : "";
										md += `${idx + 1}. [${t}](${c.url})${s}\n`;
									});
									md += `\n`;
								}
							}
						} else if (block.type === "thinking" && cfg.INCLUDE_THINKING) {
							md += Utils.formatThinkingBlock(block.thinking, cfg);
						} else if (
							block.type === "tool_result" &&
							block.name === "web_search" &&
							cfg.INCLUDE_SEARCH_RESULTS
						) {
							// Web search results in block.content[] with { type: "knowledge", title, url, metadata }
							const items = Array.isArray(block.content) ? block.content : [];
							const searchResults = items.filter((it) => it?.url);

							if (searchResults.length) {
								if (cfg.COLLAPSIBLE_SEARCH_RESULTS) {
									md += `<details>\n<summary><strong>🔍 Search Results (${searchResults.length})</strong></summary>\n\n`;
									searchResults.forEach((it, idx) => {
										const title = (it.title || it.url || "")
											.replace(/\n/g, " ")
											.trim();
										const source =
											it.metadata?.site_name || it.metadata?.site_domain || "";
										md += `${idx + 1}. [${title}](${it.url})${source ? ` — ${source}` : ""}\n`;
									});
									md += `\n</details>\n\n`;
								} else {
									md += `**🔍 Search Results (${searchResults.length}):**\n\n`;
									searchResults.forEach((it, idx) => {
										const title = (it.title || it.url || "")
											.replace(/\n/g, " ")
											.trim();
										const source =
											it.metadata?.site_name || it.metadata?.site_domain || "";
										md += `${idx + 1}. [${title}](${it.url})${source ? ` — ${source}` : ""}\n`;
									});
									md += `\n`;
								}
							}
						} else if (
							block.type === "tool_use" &&
							block.name === "web_search" &&
							cfg.INCLUDE_WEB_FEATURES &&
							cfg.INCLUDE_SEARCH_QUERIES
						) {
							// Show the query
							const q = block.input?.query;
							if (q) {
								md += `🔍 *Searching:* \`${q}\`\n\n`;
							}
						} else if (
							block.type === "tool_use" &&
							block.name === "artifacts" &&
							cfg.INCLUDE_ARTIFACTS
						) {
							const input = block.input || {};
							const artId = input.id || "artifact";
							const command = input.command || "";
							const version = input.version_uuid
								? ` (${input.version_uuid.slice(0, 8)}...)`
								: "";

							const normalizeNL = (s) =>
								typeof s === "string" ? s.replace(/\r\n/g, "\n") : "";

							// Get previous state for this artifact (if any)
							const prevState = artifactStateById.get(artId) || {
								content: null,
								language: "",
								title: artId,
								type: "",
							};

							// Current block may override title/language/type, or we inherit from previous
							const artTitle = input.title || prevState.title || artId;
							const artLang = input.language || prevState.language || "";
							const artType = input.type || prevState.type || "";

							let resolvedContent = "";
							let resolvedLabel = "";

							if (command === "create" || command === "rewrite") {
								resolvedContent = normalizeNL(input.content || "");
								resolvedLabel = command;
							} else if (command === "update") {
								const oldStr = normalizeNL(input.old_str || "");
								const newStr = normalizeNL(input.new_str || "");
								const currentContent = prevState.content
									? normalizeNL(prevState.content)
									: null;

								if (
									currentContent &&
									oldStr &&
									currentContent.includes(oldStr)
								) {
									resolvedContent = currentContent.replace(oldStr, newStr);
									resolvedLabel = "update (reconstructed)";
								} else {
									// Could not reconstruct; export the patch so it's not lost
									resolvedContent = `<<<<<<< OLD\n${oldStr}\n=======\n${newStr}\n>>>>>>> NEW`;
									resolvedLabel = "update (patch only)";
								}
							} else {
								// Unknown artifact command; best-effort export
								resolvedContent = normalizeNL(input.content || "");
								resolvedLabel = command || "artifact";
							}

							// Update stored state for this artifact ID
							artifactStateById.set(artId, {
								content: resolvedContent,
								language: artLang,
								title: artTitle,
								type: artType,
							});

							// Determine fence language: use stored/inherited language, fallback to 'diff' for patch-only
							const fenceLang = resolvedLabel.includes("patch")
								? "diff"
								: artLang;
							const headerSuffix = resolvedLabel
								? ` — ${resolvedLabel}${version}`
								: version;
							const codeBlock = Utils.makeCodeFence(resolvedContent, fenceLang);

							if (cfg.COLLAPSIBLE_ARTIFACTS) {
								// No ### for collapsible - it's inside <summary>
								const artifactSummary = `📄 Artifact: ${artTitle}${headerSuffix}`;
								md += `<details>\n<summary><strong>${artifactSummary}</strong></summary>\n\n${codeBlock}\n\n</details>\n\n`;
							} else {
								// Use ### header for non-collapsible
								const artifactHeader = `### 📄 Artifact: ${artTitle}${headerSuffix}`;
								md += `${artifactHeader}\n${codeBlock}\n\n`;
							}
						}
						// Handle create_file tool (new Claude artifact format - files created in sandbox)
						else if (
							block.type === "tool_use" &&
							block.name === "create_file" &&
							cfg.INCLUDE_ARTIFACTS
						) {
							const input = block.input || {};
							const filePath = input.path || "";
							const fileName = filePath.split("/").pop() || "unnamed_file";
							const fileText = input.file_text || "";
							const description = input.description || "";

							// Determine language from file extension
							let lang = "";
							const lower = fileName.toLowerCase();
							if (lower.endsWith(".html") || lower.endsWith(".htm"))
								lang = "html";
							else if (
								lower.endsWith(".js") ||
								lower.endsWith(".mjs") ||
								lower.endsWith(".cjs")
							)
								lang = "javascript";
							else if (lower.endsWith(".ts") || lower.endsWith(".tsx"))
								lang = "typescript";
							else if (lower.endsWith(".jsx")) lang = "jsx";
							else if (lower.endsWith(".py")) lang = "python";
							else if (lower.endsWith(".css")) lang = "css";
							else if (lower.endsWith(".scss") || lower.endsWith(".sass"))
								lang = "scss";
							else if (lower.endsWith(".json")) lang = "json";
							else if (lower.endsWith(".md") || lower.endsWith(".markdown"))
								lang = "markdown";
							else if (lower.endsWith(".xml") || lower.endsWith(".svg"))
								lang = "xml";
							else if (lower.endsWith(".yaml") || lower.endsWith(".yml"))
								lang = "yaml";
							else if (lower.endsWith(".sh") || lower.endsWith(".bash"))
								lang = "bash";
							else if (lower.endsWith(".ps1")) lang = "powershell";
							else if (lower.endsWith(".sql")) lang = "sql";
							else if (lower.endsWith(".java")) lang = "java";
							else if (lower.endsWith(".c") || lower.endsWith(".h")) lang = "c";
							else if (
								lower.endsWith(".cpp") ||
								lower.endsWith(".hpp") ||
								lower.endsWith(".cc")
							)
								lang = "cpp";
							else if (lower.endsWith(".rs")) lang = "rust";
							else if (lower.endsWith(".go")) lang = "go";
							else if (lower.endsWith(".rb")) lang = "ruby";
							else if (lower.endsWith(".php")) lang = "php";
							else if (lower.endsWith(".swift")) lang = "swift";
							else if (lower.endsWith(".kt") || lower.endsWith(".kts"))
								lang = "kotlin";
							else if (lower.endsWith(".scala")) lang = "scala";
							else if (lower.endsWith(".r")) lang = "r";
							else if (lower.endsWith(".lua")) lang = "lua";
							else if (lower.endsWith(".toml")) lang = "toml";
							else if (lower.endsWith(".ini") || lower.endsWith(".cfg"))
								lang = "ini";
							else if (lower.endsWith(".vue")) lang = "vue";

							if (fileText) {
								const codeBlock = Utils.makeCodeFence(fileText, lang);
								const header = description
									? `📄 ${description}: ${fileName}`
									: `📄 File: ${fileName}`;

								if (cfg.COLLAPSIBLE_ARTIFACTS) {
									md += `<details>\n<summary><strong>${Utils.escapeHtml(header)}</strong></summary>\n\n${codeBlock}\n\n</details>\n\n`;
								} else {
									md += `### ${header}\n${codeBlock}\n\n`;
								}
							}
						}
						// Skip visualize:read_me entirely (internal MCP plumbing)
						else if (
							(block.type === "tool_use" || block.type === "tool_result") &&
							block.name === "visualize:read_me"
						) {
							// Skip — just loads the widget design system docs
						}
						// Skip visualize:show_widget tool_result (boilerplate "content rendered" text)
						else if (
							block.type === "tool_result" &&
							block.name === "visualize:show_widget"
						) {
							// Skip — tool_result just says "Content rendered and shown to the user"
						}
						// Render visualize:show_widget as inline widget SVG or fallback
						else if (
							block.type === "tool_use" &&
							block.name === "visualize:show_widget"
						) {
							if (!cfg.INCLUDE_WIDGETS) return; // Widgets disabled — skip silently

							const input = block.input || {};
							const widgetTitle = input.title || "widget";

							// Check if this widget was selected for export (via dialog)
							const exportWidgets = data.__exportWidgets;
							if (
								exportWidgets instanceof Set &&
								!exportWidgets.has(widgetTitle)
							) {
								// User deselected this widget — emit fallback note
								md += `> 🧩 Widget: \`${widgetTitle}\` — skipped by user.\n\n`;
								return;
							}

							const cached = this.WidgetCache.get(widgetTitle);

							if (cached) {
								// We have the rendered SVG
								const svgFileName = cached.fileName;
								const svgText = cached.svgText;
								const widgetParts = [];
								let renderedAny = false;

								// ─── Markdown Inline ───
								if (cfg.WIDGET_MD_RELATIVE_PATH) {
									widgetParts.push(`![${widgetTitle}](${svgFileName})`);
									renderedAny = true;
								}

								if (cfg.WIDGET_MD_BASE64) {
									try {
										const dataUri = Utils.encodeSvgBase64(svgText);
										widgetParts.push(`![${widgetTitle}](${dataUri})`);
									} catch (_e) {
										widgetParts.push(
											`> ⚠️ Base64 encoding failed for widget: \`${widgetTitle}\``,
										);
									}
									renderedAny = true;
								}

								if (cfg.WIDGET_MD_DATAURI_TEXT) {
									try {
										const dataUri = Utils.encodeSvgDataUri(svgText);
										widgetParts.push(`![${widgetTitle}](${dataUri})`);
									} catch (_e) {
										widgetParts.push(
											`> ⚠️ Data URI encoding failed for widget: \`${widgetTitle}\``,
										);
									}
									renderedAny = true;
								}

								// ─── HTML Inline ───
								if (cfg.WIDGET_HTML_SVG_RAW) {
									widgetParts.push(svgText);
									renderedAny = true;
								}

								if (cfg.WIDGET_HTML_IMG_BASE64) {
									try {
										const dataUri = Utils.encodeSvgBase64(svgText);
										widgetParts.push(
											`<img src="${dataUri}" alt="${Utils.escapeHtml(widgetTitle)}" />`,
										);
									} catch (_e) {
										widgetParts.push(
											`> ⚠️ HTML img base64 encoding failed for widget: \`${widgetTitle}\``,
										);
									}
									renderedAny = true;
								}

								if (cfg.WIDGET_HTML_IMG_DATAURI) {
									try {
										const dataUri = Utils.encodeSvgDataUri(svgText);
										widgetParts.push(
											`<img src="${dataUri}" alt="${Utils.escapeHtml(widgetTitle)}" />`,
										);
									} catch (_e) {
										widgetParts.push(
											`> ⚠️ HTML img data URI encoding failed for widget: \`${widgetTitle}\``,
										);
									}
									renderedAny = true;
								}

								// ─── Link ───
								if (cfg.WIDGET_CLICKABLE_LINK) {
									widgetParts.push(
										`🔗 [Open widget: ${widgetTitle}](${svgFileName})`,
									);
									renderedAny = true;
								}

								if (!renderedAny) {
									widgetParts.push(
										`> 🧩 Widget: \`${widgetTitle}\` — SVG captured but no inline format enabled.`,
									);
								}

								const widgetBody = widgetParts.join("\n\n");

								if (cfg.COLLAPSIBLE_WIDGETS) {
									md += `<details>\n<summary><strong>🧩 Widget: ${Utils.escapeHtml(widgetTitle)}</strong></summary>\n\n${widgetBody}\n\n</details>\n\n`;
								} else {
									md += `**🧩 Widget: ${widgetTitle}**\n\n${widgetBody}\n\n`;
								}
							} else {
								// Not captured — graceful fallback
								const fallbackNote = [
									`> 🧩 Widget: \`${widgetTitle}\``,
									`>`,
									`> Rendered SVG was not captured during export.`,
									`> Open the widget in Claude and use **Download file** to retrieve the standalone SVG.`,
								].join("\n");

								if (cfg.COLLAPSIBLE_WIDGETS) {
									md += `<details>\n<summary><strong>🧩 Widget: ${Utils.escapeHtml(widgetTitle)} (not captured)</strong></summary>\n\n${fallbackNote}\n\n</details>\n\n`;
								} else {
									md += `${fallbackNote}\n\n`;
								}
							}
						}
						// Tool export (Claude): pair tool_use + tool_result into ONE block for consistent Input/Output
						else if (cfg.INCLUDE_TOOL_CALLS && block.type === "tool_use") {
							const name = block.name || "";
							const id = block.id;
							if (!id) return;

							const input = block.input || {};
							const desc = input.description || block.message || "";

							// web_search is exported via INCLUDE_SEARCH_QUERIES/RESULTS
							if (name === "web_search") return;

							// visualize:* tools are handled by widget/read_me logic above
							if (name.startsWith("visualize:")) return;

							// create_file: we already export file_text as an artifact; store only for nicer tool_result title
							if (name === "create_file") {
								const fp = input.path || "";
								const fn = fp ? fp.split("/").pop() : "";
								const title = `📄 create_file${desc ? ` — ${desc}` : ""}${fn ? ` (${fn})` : ""}`;
								pendingToolUses.set(id, {
									title,
									inputLang: "",
									inputText: "",
								});
								return;
							}

							let title = "";
							if (name === "bash_tool") title = `🖥️ ${desc || "bash_tool"}`;
							else if (name === "view") {
								const r = Array.isArray(input.view_range)
									? input.view_range
									: null;
								title = `🗂️ ${desc || "view"}${input.path ? ` — ${input.path}` : ""}${r ? ` [${r[0]}-${r[1]}]` : ""}`;
							} else if (name === "present_files")
								title = `📁 ${desc || "present_files"}`;
							else title = `🛠️ ${name}${desc ? ` — ${desc}` : ""}`;

							let inputLang = "json";
							let inputText = "";

							if (name === "bash_tool") {
								inputLang = "bash";
								inputText = input.command || "";
								if (!inputText) {
									const jb = parseToolJsonBlock(block.display_content);
									if (jb?.code) {
										inputLang = jb.language || "bash";
										inputText = jb.code;
									}
								}
							} else if (name === "view") {
								inputText = JSON.stringify(
									{
										path: input.path,
										view_range: input.view_range,
										description: input.description,
									},
									null,
									2,
								);
							} else if (name === "present_files") {
								inputText = JSON.stringify(
									{ filepaths: input.filepaths || [] },
									null,
									2,
								);
							} else {
								const jb = parseToolJsonBlock(block.display_content);
								if (jb?.code) {
									inputLang = jb.language || "json";
									inputText = jb.code;
								} else {
									inputText = JSON.stringify(input, null, 2);
								}
							}

							pendingToolUses.set(id, { title, inputLang, inputText });
						} else if (cfg.INCLUDE_TOOL_CALLS && block.type === "tool_result") {
							const name = block.name || "";
							// visualize:* tool_results are handled above
							if (name.startsWith("visualize:")) return;
							const tid = block.tool_use_id || "";
							const pending = tid ? pendingToolUses.get(tid) : null;

							const title =
								pending?.title ||
								`🛠️ ${name} result${block.is_error ? " (error)" : ""}`;

							let outputLang = "plaintext";
							let outputText = "";

							const jb = parseToolJsonBlock(block.display_content);
							if (jb?.code) {
								outputLang = jb.language || outputLang;
								outputText = jb.code || "";
							} else {
								const arr = Array.isArray(block.content) ? block.content : [];
								const parts = [];
								arr.forEach((item) => {
									if (!item) return;
									if (item.type === "text" && item.text) {
										parts.push(item.text);
									} else if (item.type === "local_resource") {
										const n =
											item.name ||
											(item.file_path
												? item.file_path.split("/").pop()
												: "File");
										const mt = item.mime_type || "";
										const fp = item.file_path || "";
										parts.push(
											`Presented: ${n}${mt ? ` (${mt})` : ""}${fp ? ` — ${fp}` : ""}`,
										);
									}
								});
								outputText = parts.join("\n\n").trim();
							}

							// bash_tool result envelope -> pretty output
							if (name === "bash_tool" && outputText) {
								const m = outputText.match(/^\s*\{[\s\S]*\}\s*$/);
								if (m) {
									try {
										const parsed = JSON.parse(outputText);
										const stdout = parsed.stdout || "";
										const stderr = parsed.stderr || "";
										const rc =
											parsed.returncode !== undefined
												? `returncode: ${parsed.returncode}\n`
												: "";
										outputText =
											`${rc}${stdout}${stderr ? `\n${stderr}` : ""}`.trim();
									} catch (_e) {
										/* ignore */
									}
								}
							}

							renderToolIO(
								title,
								pending?.inputLang || "",
								pending?.inputText || "",
								outputLang,
								outputText,
							);

							if (tid) pendingToolUses.delete(tid);
						}
					});
				}

				if (cfg.COLLAPSIBLE_MESSAGES) {
					md += `</details>\n\n---\n\n`;
				} else {
					md += `---\n\n`;
				}
			});

			return {
				content: md,
				filename: `${Utils.sanitizeFilename(title, "Claude_Export")}.md`,
				stats: {
					total: messagesToExport.length,
					exported: exportedCount,
				},
			};
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// PROVIDER: GROK
	// ═══════════════════════════════════════════════════════════════════════════
	const GrokProvider = {
		name: "Grok",
		hostPattern: /grok\.com/,

		matches(url) {
			return this.hostPattern.test(url);
		},

		extractChatId(url) {
			const match = url.match(/\/c\/([a-z0-9-]+)/);
			return match ? match[1] : null;
		},

		async fetchChat(chatId) {
			// Goal: export what you're CURRENTLY VIEWING.
			// Grok encodes the selected variant in the URL (?rid=...).
			const activeRid = new URLSearchParams(location.search).get("rid");

			// 1) Snapshot list from server
			const snapshotUrl = `/rest/app-chat/conversations/${chatId}/responses`;
			const snapshotResp = await fetch(snapshotUrl, {
				method: "GET",
				headers: { Accept: "application/json" },
				credentials: "include",
				cache: "no-store",
			});

			if (!snapshotResp.ok)
				throw new Error(`API error: ${snapshotResp.status}`);
			const snapshot = await snapshotResp.json();

			// 2) Build a set of IDs to hydrate (this is what load-responses expects)
			const ids = new Set();
			(snapshot.responses || []).forEach((r) => {
				if (r?.responseId) ids.add(r.responseId);
			});
			(snapshot.inflightResponses || []).forEach((r) => {
				if (r?.responseId) ids.add(r.responseId);
			});
			if (activeRid) ids.add(activeRid);

			// Useful on Grok: stores IDs you have viewed/selected in this browser profile
			try {
				const viewed = JSON.parse(
					localStorage.getItem("responseViewedMap") || "{}",
				);
				// biome-ignore lint/suspicious/useIterableCallbackReturn: Set.add returns Set but forEach ignores it
				Object.keys(viewed || {}).forEach((id) => ids.add(id));
			} catch (_e) {
				/* ignore */
			}

			const loadUrl = `/rest/app-chat/conversations/${chatId}/load-responses`;

			const loadOnce = async () => {
				if (!ids.size) return null;
				try {
					const resp = await fetch(loadUrl, {
						method: "POST",
						headers: {
							Accept: "application/json",
							"Content-Type": "application/json",
						},
						credentials: "include",
						cache: "no-store",
						body: JSON.stringify({ responseIds: Array.from(ids) }),
					});
					if (!resp.ok) return null;
					return await resp.json();
				} catch (_e) {
					return null;
				}
			};

			// Fetch file attachment content from assets.grok.com
			const fetchAttachmentContent = async (fileUri) => {
				if (!fileUri) return null;
				try {
					const url = `https://assets.grok.com/${fileUri}`;
					const resp = await fetch(url, {
						method: "GET",
						credentials: "include",
						cache: "no-store",
					});
					if (!resp.ok) return null;
					return await resp.text();
				} catch (e) {
					console.warn(
						"[Grok Exporter] Failed to fetch attachment:",
						fileUri,
						e,
					);
					return null;
				}
			};

			// Resolve Ghost ID to real file path via bridge endpoint
			// Old conversations store attachment IDs that require translation
			const resolveGhostId = async (ghostId) => {
				if (!ghostId) return null;
				try {
					const url = `/rest/assets/${ghostId}`;
					const resp = await fetch(url, {
						method: "GET",
						credentials: "include",
						cache: "no-store",
					});
					if (!resp.ok) return null;
					return await resp.json();
				} catch (e) {
					console.warn(
						"[Grok Exporter] Failed to resolve Ghost ID:",
						ghostId,
						e,
					);
					return null;
				}
			};

			const loaded = await loadOnce();

			// 3) Merge snapshot + hydrated responses by responseId
			const byId = new Map();
			const ingest = (arr) => {
				(arr || []).forEach((r) => {
					if (r?.responseId) byId.set(r.responseId, r);
				});
			};

			ingest(snapshot.responses);
			ingest(snapshot.inflightResponses);
			ingest(loaded?.responses);

			// 4) If we have an active rid, try to ensure its ancestor chain is present
			// by adding missing parentResponseId values and re-hydrating a few times.
			if (activeRid && byId.has(activeRid)) {
				for (let i = 0; i < 6; i++) {
					const missing = [];
					let cur = byId.get(activeRid);
					const seen = new Set();

					while (cur?.responseId && !seen.has(cur.responseId)) {
						seen.add(cur.responseId);
						const pid = cur.parentResponseId;
						if (pid && !byId.has(pid) && !ids.has(pid)) missing.push(pid);
						if (!pid) break;
						cur = byId.get(pid);
					}

					if (!missing.length) break;
					// biome-ignore lint/suspicious/useIterableCallbackReturn: Set.add returns Set but forEach ignores it
					missing.forEach((id) => ids.add(id));

					const more = await loadOnce();
					ingest(more?.responses);
				}
			}

			const allResponses = Array.from(byId.values());

			// Resolve Ghost IDs for old conversations (The Repair Step)
			// Old conversations have fileAttachments (Ghost IDs) but empty fileAttachmentsMetadata
			for (const response of allResponses) {
				if (
					response.fileAttachments?.length > 0 &&
					!response.fileAttachmentsMetadata?.length
				) {
					response.fileAttachmentsMetadata = [];
					for (const ghostId of response.fileAttachments) {
						const assetData = await resolveGhostId(ghostId);
						if (assetData?.key) {
							response.fileAttachmentsMetadata.push({
								fileUri: assetData.key,
								fileName: assetData.name || assetData.fileName || ghostId,
								fileMimeType:
									assetData.mimeType || assetData.contentType || "text/plain",
							});
						}
					}
				}
			}

			// Fetch attachment contents for all responses
			for (const response of allResponses) {
				if (response.fileAttachmentsMetadata?.length > 0) {
					for (const att of response.fileAttachmentsMetadata) {
						if (att.fileUri) {
							const content = await fetchAttachmentContent(att.fileUri);
							if (content !== null) {
								att.__fetchedContent = content;
							}
						}
					}
				}
			}

			return {
				...snapshot,
				responses: allResponses,
				__activeRid: activeRid,
			};
		},

		cleanGrokMessage(text) {
			if (!text) return "";
			// Remove <grok:render> citation tags
			return text.replace(/<grok:render[^>]*>[\s\S]*?<\/grok:render>/g, "");
		},

		generateMarkdown(data, settings = null) {
			// Use provider-specific settings if provided, otherwise fall back to CONFIG
			const cfg = settings || CONFIG;
			console.log(
				"[Chat Exporter] GrokProvider.generateMarkdown() using cfg.INCLUDE_USER_MESSAGES:",
				cfg.INCLUDE_USER_MESSAGES,
				"cfg.INCLUDE_ASSISTANT_MESSAGES:",
				cfg.INCLUDE_ASSISTANT_MESSAGES,
			);

			const activeRid =
				data?.__activeRid ||
				new URLSearchParams(location.search).get("rid") ||
				null;

			// Combine + de-dupe by responseId
			const combined = [
				...(data.responses || []),
				...(data.inflightResponses || []),
			].filter((r) => r && typeof r === "object");

			const byId = new Map();
			combined.forEach((r) => {
				if (r?.responseId) byId.set(r.responseId, r);
			});

			const buildChainFromRid = (rid) => {
				const chain = [];
				const seen = new Set();
				let cur = byId.get(rid);

				while (cur?.responseId && !seen.has(cur.responseId)) {
					seen.add(cur.responseId);
					chain.push(cur);
					const pid = cur.parentResponseId;
					if (!pid) break;
					cur = byId.get(pid);
				}

				return chain.reverse();
			};

			let responses;
			if (cfg.EXPORT_ALL_REGENERATIONS) {
				// Export ALL responses chronologically, including regenerations
				responses = combined.slice().sort((a, b) => {
					const ta = a?.createTime ? new Date(a.createTime).getTime() : 0;
					const tb = b?.createTime ? new Date(b.createTime).getTime() : 0;
					return ta - tb;
				});

				const seen = new Set();
				responses = responses.filter((r) => {
					const id =
						r?.responseId ||
						`${r?.sender || "unknown"}:${r?.createTime || ""}:${(r?.message || "").slice(0, 32)}`;
					if (seen.has(id)) return false;
					seen.add(id);
					return true;
				});
			} else if (activeRid && byId.has(activeRid)) {
				// Export only the currently selected response chain
				responses = buildChainFromRid(activeRid);
			} else {
				// Fallback: no active rid, export all chronologically
				responses = combined.slice().sort((a, b) => {
					const ta = a?.createTime ? new Date(a.createTime).getTime() : 0;
					const tb = b?.createTime ? new Date(b.createTime).getTime() : 0;
					return ta - tb;
				});

				const seen = new Set();
				responses = responses.filter((r) => {
					const id =
						r?.responseId ||
						`${r?.sender || "unknown"}:${r?.createTime || ""}:${(r?.message || "").slice(0, 32)}`;
					if (seen.has(id)) return false;
					seen.add(id);
					return true;
				});
			}

			const firstHuman = responses.find((r) => r.sender === "human");
			const titleSource =
				firstHuman?.message?.substring(0, 60) || data?.title || "Grok_Export";
			const title = Utils.sanitize(titleSource, "Grok_Export");

			let md = `# ${title}\n\n`;

			if (cfg.INCLUDE_HEADER) {
				md += `> **Provider:** Grok  \n`;
				md += `> **Date:** ${new Date().toLocaleString()}  \n`;
				md += `> **Source:** [Grok.com](${location.href})  \n`;
				if (cfg.INCLUDE_ACTIVE_LEAF_INFO && activeRid) {
					md += `> **Active Response (rid):** \`${activeRid}\`  \n`;
				}
				md += `\n---\n\n`;
			}

			if (!responses.length)
				return {
					content: md,
					filename: "empty.md",
					stats: {
						total: 0,
						exported: 0,
						modelsDetected: 0,
						assistantCount: 0,
					},
				};

			let turnNumber = 0;
			let exportedCount = 0;
			let assistantCount = 0;
			const modelsFound = new Set();

			responses.forEach((msg) => {
				const isHuman = msg.sender === "human";
				const role = isHuman ? "USER" : "GROK";

				// Skip based on config
				if (isHuman && !cfg.INCLUDE_USER_MESSAGES) return;
				if (!isHuman && !cfg.INCLUDE_ASSISTANT_MESSAGES) return;

				turnNumber++;
				exportedCount++;
				if (!isHuman) {
					assistantCount++;
					if (msg.model) modelsFound.add(msg.model);
				}

				// Build header with optional turn number
				let header = role;
				if (cfg.INCLUDE_TURN_NUMBERS) {
					header = `[${turnNumber}] ${header}`;
				}

				if (cfg.COLLAPSIBLE_MESSAGES) {
					md += `<details>\n<summary><strong>${header}</strong></summary>\n\n`;
				} else {
					md += `## ${header}\n\n`;
				}

				// Optional: show timestamp
				if (cfg.INCLUDE_TIMESTAMPS && msg.createTime) {
					md += `*${new Date(msg.createTime).toLocaleString()}*\n\n`;
				}

				// Optional: show message ID
				if (cfg.INCLUDE_MESSAGE_IDS && msg.responseId) {
					md += `\`ID: ${msg.responseId}\`\n\n`;
				}

				// Model info for assistant
				if (cfg.INCLUDE_MODEL_INFO && !isHuman && msg.model) {
					md += `*Model: ${msg.model}*\n\n`;
				}

				// Thinking duration
				if (
					cfg.INCLUDE_THINKING_DURATION &&
					msg.thinkingStartTime &&
					msg.thinkingEndTime
				) {
					const start = new Date(msg.thinkingStartTime);
					const end = new Date(msg.thinkingEndTime);
					const duration = ((end - start) / 1000).toFixed(1);
					md += `*💭 Thinking time: ${duration}s*\n\n`;
				}

				// File attachments (with fetched content if available)
				if (cfg.INCLUDE_ATTACHMENTS) {
					// Handle file attachments with metadata (contains fetched content)
					if (msg.fileAttachmentsMetadata?.length > 0) {
						msg.fileAttachmentsMetadata.forEach((att) => {
							const name = att.fileName || "Unknown file";
							const mimeType = att.fileMimeType || "";
							const content = att.__fetchedContent || null;

							if (content) {
								// Determine language hint from mime type or filename
								let lang = "";
								if (mimeType.includes("javascript")) lang = "javascript";
								else if (mimeType.includes("python")) lang = "python";
								else if (mimeType.includes("markdown")) lang = "markdown";
								else if (mimeType.includes("json")) lang = "json";
								else if (mimeType.includes("html")) lang = "html";
								else if (mimeType.includes("css")) lang = "css";
								else if (mimeType.includes("xml")) lang = "xml";
								else if (name.endsWith(".ps1")) lang = "powershell";
								else if (name.endsWith(".sh") || name.endsWith(".bash"))
									lang = "bash";
								else if (name.endsWith(".bat") || name.endsWith(".cmd"))
									lang = "batch";
								else if (name.endsWith(".ts")) lang = "typescript";
								else lang = mimeType.split("/")[1] || "";

								const lineCount = (content.match(/\n/g) || []).length + 1;

								const fenced = Utils.makeCodeFence(content, lang);

								if (cfg.COLLAPSIBLE_ATTACHMENTS) {
									md += `<details>\n<summary><strong>📎 Attached File: ${Utils.escapeHtml(name)}</strong> (${lineCount} lines)</summary>\n\n${fenced}\n\n</details>\n\n`;
								} else {
									md += `**📎 Attached File: ${name}** (${lineCount} lines)\n\n${fenced}\n\n`;
								}
							} else {
								// Content not fetched
								if (cfg.COLLAPSIBLE_ATTACHMENTS) {
									md += `<details>\n<summary><strong>📎 Attached: ${Utils.escapeHtml(name)}</strong></summary>\n\n*(File content could not be fetched)*\n\n</details>\n\n`;
								} else {
									md += `> 📎 **Attached:** ${name}\n\n`;
								}
							}
						});
					}
					// Fallback for old-style fileAttachments (just IDs, no metadata)
					else if (
						msg.fileAttachments?.length > 0 &&
						!msg.fileAttachmentsMetadata?.length
					) {
						msg.fileAttachments.forEach((attId) => {
							if (cfg.COLLAPSIBLE_ATTACHMENTS) {
								md += `<details>\n<summary><strong>📎 Attached: ${attId}</strong></summary>\n\n*(File content not available)*\n\n</details>\n\n`;
							} else {
								md += `> 📎 **Attached:** ${attId}\n\n`;
							}
						});
					}

					// Image attachments
					if (msg.imageAttachments?.length > 0) {
						const count = msg.imageAttachments.length;
						if (cfg.COLLAPSIBLE_ATTACHMENTS) {
							md += `<details>\n<summary><strong>🖼️ Images attached: ${count}</strong></summary>\n\n*(Image previews not available via API)*\n\n</details>\n\n`;
						} else {
							md += `> 🖼️ **Images attached:** ${count}\n\n`;
						}
					}
				}

				// Main message content (cleaned of citation tags)
				let cleanedMessage = this.cleanGrokMessage(msg.message);
				if (cleanedMessage) {
					// Process code blocks based on settings
					cleanedMessage = Utils.processCodeBlocks(cleanedMessage, cfg);
					md += `${cleanedMessage}\n\n`;
				}

				// Sources - Grok uses webSearchResults (no inline capability, list only)
				if (cfg.INCLUDE_SOURCES_LIST && msg.webSearchResults?.length > 0) {
					const results = msg.webSearchResults;
					if (cfg.COLLAPSIBLE_SOURCES_LIST) {
						md += `<details>\n<summary><strong>📚 Sources (${results.length})</strong></summary>\n\n`;
						results.forEach((result, idx) => {
							if (result.url) {
								const title = (result.title || result.url)
									.replace(/\n/g, " ")
									.trim();
								const siteName = result.siteName ? ` — ${result.siteName}` : "";
								md += `${idx + 1}. [${title}](${result.url})${siteName}\n`;
								if (result.preview) {
									const preview = Utils.escapeHtml(
										result.preview.substring(0, 150).replace(/\n/g, " ").trim(),
									);
									md += `   > ${preview}...\n\n`;
								}
							}
						});
						md += `</details>\n\n`;
					} else {
						md += `**📚 Sources (${results.length}):**\n\n`;
						results.forEach((result, idx) => {
							if (result.url) {
								const title = (result.title || result.url)
									.replace(/\n/g, " ")
									.trim();
								const siteName = result.siteName ? ` — ${result.siteName}` : "";
								md += `${idx + 1}. [${title}](${result.url})${siteName}\n`;
								if (result.preview) {
									const preview = Utils.escapeHtml(
										result.preview.substring(0, 150).replace(/\n/g, " ").trim(),
									);
									md += `   > ${preview}...\n\n`;
								}
							}
						});
						md += `\n`;
					}
				}

				if (cfg.COLLAPSIBLE_MESSAGES) {
					md += `</details>\n\n---\n\n`;
				} else {
					md += `---\n\n`;
				}
			});

			return {
				content: md,
				filename: `${Utils.sanitizeFilename(title, "Grok_Export")}.md`,
				stats: {
					total: responses.length,
					exported: exportedCount,
					modelsDetected: modelsFound.size,
					assistantCount: assistantCount,
				},
			};
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// PROVIDER: ARENA
	// ═══════════════════════════════════════════════════════════════════════════
	const ArenaProvider = {
		name: "Arena",
		hostPattern: /arena\.ai/,

		matches(url) {
			return this.hostPattern.test(url);
		},

		extractChatId(url) {
			// Handles: /c/{id}, /chat/{id}, /{locale}/c/{id}, /{locale}/chat/{id}
			const match = url.match(/\/(?:c|chat)\/([a-zA-Z0-9-]+)/);
			if (match && match[1] !== "new") {
				return match[1];
			}
			return null;
		},

		/**
		 * Download an image from a URL and return as base64 data URI.
		 * Uses GM_xmlhttpRequest to bypass CORS for signed R2 URLs.
		 * @param {string} url - Image URL (typically a signed R2/Cloudflare URL)
		 * @returns {Promise<{blob: Blob, dataUri: string}|null>} - Blob + data URI, or null on failure
		 */
		fetchImage(url) {
			return Utils.fetchImageData(url).then((result) => {
				if (!result?.ok) {
					const status = result?.status || 0;
					console.warn(
						"[Chat Exporter] Image fetch failed:",
						status,
						String(url || "").substring(0, 80),
						result?.error || "",
					);
					return null;
				}
				return { blob: result.blob, dataUri: result.dataUri };
			});
		},

		async fetchChat(chatId, settings = null) {
			const response = await fetch(`/api/evaluation/${chatId}`, {
				credentials: "include",
				headers: { Accept: "application/json" },
			});

			if (!response.ok) {
				throw new Error(`API error: ${response.status}`);
			}

			const data = await response.json();

			if (
				!data.messages ||
				!Array.isArray(data.messages) ||
				data.messages.length === 0
			) {
				throw new Error("No messages found");
			}

			// Download image attachments (signed URLs expire ~1h)
			try {
				const s = settings || Settings.load(this.name);
				if (ImageOptions.needsDownload(s)) {
					for (const msg of data.messages) {
						const attachments = Array.isArray(msg.experimental_attachments)
							? msg.experimental_attachments
							: [];
						for (const att of attachments) {
							if (!att?.url || !att?.contentType?.startsWith("image/"))
								continue;
							console.log(
								"[Chat Exporter] Downloading image:",
								(att.name || "unnamed").split("/").pop(),
							);
							const result = await this.fetchImage(att.url);
							if (result) {
								att.__base64DataUri = result.dataUri;
								att.__blob = result.blob;
							} else {
								att.__fetchError = "Download failed";
							}
						}
					}
				}
			} catch (e) {
				console.warn("[Chat Exporter] Failed to download Arena images:", e);
			}

			return data;
		},

		/**
		 * Extract model names from DOM in display order.
		 * The API only provides model UUIDs, so we scrape the visible names.
		 * These correspond 1:1 with assistant messages from the API.
		 */
		getModelNamesFromDOM() {
			const selectors = [
				// Primary: sticky headers in message list showing model name
				"ol.mt-8 div.sticky span.truncate",
				'ol[class*="mt-8"] div[class*="sticky"] span[class*="truncate"]',
				// Fallback: any truncate span near model icons
				'[class*="bg-surface-primary"] [class*="sticky"] span.truncate',
			];

			for (const selector of selectors) {
				const elements = document.querySelectorAll(selector);
				if (elements.length > 0) {
					return [...elements]
						.map((el) => el.textContent?.trim())
						.filter(Boolean);
				}
			}

			return [];
		},

		generateMarkdown(data, settings = null) {
			// Use provider-specific settings if provided, otherwise fall back to CONFIG
			const cfg = settings || CONFIG;
			console.log(
				"[Chat Exporter] ArenaProvider.generateMarkdown() using cfg.INCLUDE_USER_MESSAGES:",
				cfg.INCLUDE_USER_MESSAGES,
				"cfg.INCLUDE_ASSISTANT_MESSAGES:",
				cfg.INCLUDE_ASSISTANT_MESSAGES,
			);

			// Use first user message as fallback title (like old Arena script)
			const firstUserMsg = data.messages?.find((m) => m.role === "user");
			const titleSource =
				data.title || firstUserMsg?.content?.substring(0, 60) || "Arena_Export";
			const title = Utils.sanitize(titleSource, "Arena_Export");
			const chatId = data.id || "unknown";
			const createdAt = data.createdAt
				? new Date(data.createdAt).toLocaleString()
				: new Date().toLocaleString();

			let md = `# ${title}\n\n`;

			if (cfg.INCLUDE_HEADER) {
				md += `> **Provider:** Arena  \n`;
				md += `> **Date:** ${createdAt}  \n`;
				md += `> **Chat ID:** \`${chatId}\`  \n`;
				md += `> **Source:** [Arena](${location.href})  \n`;
				md += `\n---\n\n`;
			}

			if (!data.messages || data.messages.length === 0) {
				return {
					content: md,
					filename: "empty.md",
					stats: {
						total: 0,
						exported: 0,
						modelsDetected: 0,
						assistantCount: 0,
					},
				};
			}

			// Pre-process: assign turn numbers and detect battle mode (parallel responses)
			// Group messages by parent to detect parallel assistant responses
			const messagesByParent = new Map();
			data.messages.forEach((msg) => {
				const parentKey = msg.parentMessageIds?.[0] || "root";
				if (!messagesByParent.has(parentKey)) {
					messagesByParent.set(parentKey, []);
				}
				messagesByParent.get(parentKey).push(msg);
			});

			// Assign turn numbers and battle position labels
			const processedMessages = [];
			let currentTurn = 0;

			data.messages.forEach((msg) => {
				const parentKey = msg.parentMessageIds?.[0] || "root";
				const siblings = messagesByParent.get(parentKey) || [];

				// Check if this is the first message in a group of siblings
				const isFirstInGroup = siblings[0]?.id === msg.id;

				if (isFirstInGroup) {
					currentTurn++;
				}

				// Detect battle mode: multiple assistant messages with same parent
				const isBattle =
					siblings.length > 1 &&
					msg.role === "assistant" &&
					siblings.filter((s) => s.role === "assistant").length > 1;

				const position = msg.participantPosition || "";
				const turnLabel =
					isBattle && position
						? `${currentTurn}${position.toUpperCase()}`
						: `${currentTurn}`;

				processedMessages.push({
					...msg,
					_turnNumber: currentTurn,
					_turnLabel: turnLabel,
					_isBattle: isBattle,
					_position: position,
				});
			});

			// Sort to ensure consistent ordering: within same turn, sort by participantPosition (a before b)
			processedMessages.sort((a, b) => {
				if (a._turnNumber !== b._turnNumber) {
					return a._turnNumber - b._turnNumber;
				}
				// Within same turn, sort by position
				return (a._position || "").localeCompare(b._position || "");
			});

			// Detect mode from API response
			// Arena has 3 modes:
			//   "direct"      - single model, user selects it
			//   "side-by-side"- two models, user selects both, models visible
			//   "battle"      - two models, blind comparison, models hidden until vote
			// Both "battle" and "side-by-side" use participantPosition 'a'/'b' for the two responses
			const isBattleMode =
				data.mode === "battle" || data.mode === "side-by-side";

			// Get model names from DOM
			// In direct mode: DOM uses flex-col-reverse (newest first), so reverse to get chronological order
			// In dual-model modes: DOM shows models as left/right slides, no reversal needed
			const modelNamesFromDOM = cfg.INCLUDE_MODEL_INFO
				? this.getModelNamesFromDOM()
				: [];

			console.log(
				"[Chat Exporter] Arena mode:",
				isBattleMode ? "battle" : "direct",
			);
			console.log(
				"[Chat Exporter] modelNamesFromDOM (raw from DOM):",
				JSON.stringify(modelNamesFromDOM),
			);

			// Only reverse for direct mode (chronological order needed)
			if (!isBattleMode && modelNamesFromDOM.length > 0) {
				modelNamesFromDOM.reverse();
				console.log(
					"[Chat Exporter] modelNamesFromDOM (after reverse for direct mode):",
					JSON.stringify(modelNamesFromDOM),
				);
			}

			// Build model name lookup function
			const getModelName = (msg, assistantIndex) => {
				if (!cfg.INCLUDE_MODEL_INFO || !modelNamesFromDOM.length) return null;

				if (isBattleMode) {
					// Dual-model mode (battle/side-by-side): use participantPosition to select model
					// DOM slide order matches participantPosition: left slide = 'a', right slide = 'b'
					const pos = msg._position || "";
					const result =
						pos === "a"
							? modelNamesFromDOM[0]
							: pos === "b"
								? modelNamesFromDOM[1]
								: null;
					console.log("[Chat Exporter] getModelName battle:", {
						msgId: msg.id,
						pos,
						result,
						modelNamesFromDOM,
					});
					return result;
				} else {
					// Direct mode: use sequential assistant message index
					const result = modelNamesFromDOM[assistantIndex] || null;
					console.log("[Chat Exporter] getModelName direct:", {
						msgId: msg.id,
						assistantIndex,
						result,
					});
					return result;
				}
			};

			let exportedCount = 0;
			let assistantCount = 0;
			let assistantIndex = 0;
			let imagesEmbedded = 0;

			processedMessages.forEach((msg) => {
				const isUser = msg.role === "user";
				const role = isUser ? "USER" : "ASSISTANT";

				// Skip based on config
				if (isUser && !cfg.INCLUDE_USER_MESSAGES) return;
				if (!isUser && !cfg.INCLUDE_ASSISTANT_MESSAGES) return;

				exportedCount++;
				if (!isUser) assistantCount++;

				// Build role header with optional turn number and model name
				let roleHeader = role;
				if (cfg.INCLUDE_TURN_NUMBERS) {
					roleHeader = `[${msg._turnLabel}] ${roleHeader}`;
				}
				if (!isUser && cfg.INCLUDE_MODEL_INFO) {
					const modelName = getModelName(msg, assistantIndex);
					if (modelName) {
						roleHeader = `${roleHeader} (${modelName})`;
					}
					assistantIndex++;
				}

				if (cfg.COLLAPSIBLE_MESSAGES) {
					md += `<details>\n<summary><strong>${roleHeader}</strong></summary>\n\n`;
				} else {
					md += `## ${roleHeader}\n\n`;
				}

				// Optional: timestamp
				if (cfg.INCLUDE_TIMESTAMPS && msg.createdAt) {
					md += `*${new Date(msg.createdAt).toLocaleString()}*\n\n`;
				}

				// Optional: message ID
				if (cfg.INCLUDE_MESSAGE_IDS && msg.id) {
					md += `\`ID: ${msg.id}\`\n\n`;
				}

				// Reasoning/thinking block (Arena uses "reasoning" field)
				if (cfg.INCLUDE_THINKING && msg.reasoning) {
					md += Utils.formatThinkingBlock(msg.reasoning, cfg);
				}

				// Image attachments (experimental_attachments with image content types)
				if (
					ImageOptions.hasAny(cfg) &&
					msg.experimental_attachments?.length > 0
				) {
					const imageAtts = msg.experimental_attachments.filter((att) =>
						att?.contentType?.startsWith("image/"),
					);
					const wantsVisualOrLink = !!(
						cfg.IMAGE_MD_RELATIVE_PATH ||
						cfg.IMAGE_MD_BASE64 ||
						cfg.IMAGE_MD_REMOTE_URL ||
						cfg.IMAGE_HTML_IMG_BASE64 ||
						cfg.IMAGE_HTML_IMG_REMOTE ||
						cfg.IMAGE_CLICKABLE_WEB_LINK
					);
					if (wantsVisualOrLink) {
						const imageParts = [];
						imageAtts.forEach((att, idx) => {
							const rawName = att.name
								? att.name.split("/").pop()
								: `image_${idx + 1}`;
							const fileName = Utils.sanitizeFilesystemName(rawName);
							const remoteUrl = att.url || "";
							let renderedAny = false;

							// ─── Markdown Inline ───
							if (cfg.IMAGE_MD_RELATIVE_PATH && att.__blob) {
								imageParts.push(`![${fileName}](${fileName})`);
								imagesEmbedded++;
								renderedAny = true;
							}

							if (cfg.IMAGE_MD_BASE64 && att.__base64DataUri) {
								imageParts.push(`![${fileName}](${att.__base64DataUri})`);
								imagesEmbedded++;
								renderedAny = true;
							}

							if (cfg.IMAGE_MD_REMOTE_URL && remoteUrl) {
								imageParts.push(`![${fileName}](${remoteUrl})`);
								imagesEmbedded++;
								renderedAny = true;
							}

							// ─── HTML Inline ───
							if (cfg.IMAGE_HTML_IMG_BASE64 && att.__base64DataUri) {
								imageParts.push(
									`<img src="${att.__base64DataUri}" alt="${Utils.escapeHtml(fileName)}" />`,
								);
								imagesEmbedded++;
								renderedAny = true;
							}

							if (cfg.IMAGE_HTML_IMG_REMOTE && remoteUrl) {
								imageParts.push(
									`<img src="${remoteUrl}" alt="${Utils.escapeHtml(fileName)}" />`,
								);
								imagesEmbedded++;
								renderedAny = true;
							}

							// ─── Link ───
							if (cfg.IMAGE_CLICKABLE_WEB_LINK) {
								const linkTarget = remoteUrl || (att.__blob ? fileName : "");
								if (linkTarget) {
									imageParts.push(
										`🔗 [Open image: ${fileName}](${linkTarget})`,
									);
									renderedAny = true;
								}
							}
							if (cfg.IMAGE_CLICKABLE_FILE_LINK && att.__blob && fileName) {
								imageParts.push(`📎 [Open file: ${fileName}](${fileName})`);
								renderedAny = true;
							}

							if (!renderedAny) {
								const reason = att.__fetchError || "not downloaded";
								imageParts.push(
									`> 🖼️ **Image:** ${Utils.escapeHtml(fileName)} *(${att.contentType} — ${reason})*`,
								);
							}
						});

						// Output collected images (with or without collapsible wrapper)
						if (imageParts.length > 0) {
							const imageBody = imageParts.join("\n\n");
							if (cfg.COLLAPSIBLE_IMAGES) {
								md += `<details>\n<summary><strong>🖼️ Images (${imageParts.length})</strong></summary>\n\n${imageBody}\n\n</details>\n\n`;
							} else {
								md += `${imageBody}\n\n`;
							}
						}
					}
				}

				// Main content with optional inline citations
				let content = msg.content || "";

				// Collect sources for this message
				let sources = [];
				if (msg.sources?.length > 0) {
					sources = msg.sources.filter((s) => s?.url);

					// Insert inline numeric superscript citations (if enabled)
					if (
						cfg.INCLUDE_WEB_FEATURES &&
						cfg.INCLUDE_SOURCES &&
						sources.length > 0
					) {
						// Build insertions with source index (1-based)
						const insertions = [];
						sources.forEach((source, sourceIdx) => {
							if (source.charLocation?.length > 0) {
								source.charLocation.forEach((pos) => {
									insertions.push({
										pos: pos,
										num: sourceIdx + 1,
										url: source.url,
									});
								});
							}
						});

						// Sort: descending by position, then descending by num for same position
						// This ensures [1][2][3] order when multiple sources cite same position
						insertions.sort((a, b) => {
							if (a.pos !== b.pos) return b.pos - a.pos;
							return b.num - a.num;
						});

						// Insert numeric superscript links
						insertions.forEach((ins) => {
							const insertPos = Math.min(ins.pos, content.length);
							content =
								content.slice(0, insertPos) +
								`<sup>[[${ins.num}](${ins.url})]</sup>` +
								content.slice(insertPos);
						});
					}
				}

				content = Utils.processCodeBlocks(content, cfg);
				md += `${content}\n\n`;

				// Add sources list section after content (if enabled)
				if (
					cfg.INCLUDE_WEB_FEATURES &&
					cfg.INCLUDE_SOURCES_LIST &&
					sources.length > 0
				) {
					if (cfg.COLLAPSIBLE_SOURCES_LIST) {
						md += `<details>\n<summary><strong>📚 Sources (${sources.length})</strong></summary>\n\n`;
						sources.forEach((source, idx) => {
							const title = (source.title || source.url)
								.replace(/\n/g, " ")
								.trim();
							md += `${idx + 1}. [${title}](${source.url})\n`;
						});
						md += `\n</details>\n\n`;
					} else {
						md += `**📚 Sources (${sources.length}):**\n\n`;
						sources.forEach((source, idx) => {
							const title = (source.title || source.url)
								.replace(/\n/g, " ")
								.trim();
							md += `${idx + 1}. [${title}](${source.url})\n`;
						});
						md += `\n`;
					}
				}

				if (cfg.COLLAPSIBLE_MESSAGES) {
					md += `</details>\n\n---\n\n`;
				} else {
					md += `---\n\n`;
				}
			});

			return {
				content: md,
				filename: `${Utils.sanitizeFilename(title, "Arena_Export")}.md`,
				stats: {
					total: data.messages.length,
					exported: exportedCount,
					modelsDetected: modelNamesFromDOM.length,
					assistantCount: assistantCount,
					imagesEmbedded: imagesEmbedded,
				},
			};
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// PROVIDER: CHATGPT
	// ═══════════════════════════════════════════════════════════════════════════
	const ChatGPTProvider = {
		name: "ChatGPT",
		hostPattern: /chatgpt\.com/,

		matches(url) {
			return this.hostPattern.test(url);
		},

		extractChatId(url) {
			const match = url.match(/\/c\/([0-9a-fA-F-]+)/);
			return match ? match[1] : null;
		},

		async fetchChat(chatId, settings = null) {
			let token = null;
			try {
				// ChatGPT requires a Bearer token; 404 is returned if it's missing or invalid
				const sessionResp = await fetch("/api/auth/session");
				if (sessionResp.ok) {
					const sessionData = await sessionResp.json();
					token = sessionData.accessToken;
				}
			} catch (e) {
				console.warn(
					"[Chat Exporter] Failed to fetch ChatGPT session token:",
					e,
				);
			}

			const headers = { Accept: "application/json" };
			if (token) {
				headers.Authorization = `Bearer ${token}`;
			}

			const url = `/backend-api/conversation/${chatId}`;
			const resp = await fetch(url, {
				headers,
				credentials: "include",
			});

			if (!resp.ok) {
				if (resp.status === 404 && !token) {
					throw new Error(
						"API error 404: Missing authorization token (session fetch failed).",
					);
				}
				throw new Error(`API error: ${resp.status}`);
			}

			const data = await resp.json();
			const cfg = settings || CONFIG;
			if (!ImageOptions.hasAny(cfg)) return data;

			const signedUrlByFileId = (() => {
				const out = new Map();
				const collect = (rawUrl) => {
					if (!rawUrl) return;
					try {
						const u = new URL(rawUrl, location.origin);
						if (!u.pathname.includes("/backend-api/estuary/content")) return;
						const fileId = u.searchParams.get("id");
						if (!fileId || !/^file_[a-zA-Z0-9]+$/.test(fileId)) return;
						const hasSig = !!u.searchParams.get("sig");
						const existing = out.get(fileId);
						if (!existing || hasSig) out.set(fileId, u.toString());
					} catch (_) {
						/* ignore malformed URL */
					}
				};
				try {
					document
						.querySelectorAll(
							'img[src*="/backend-api/estuary/content?id=file_"]',
						)
						.forEach((img) => {
							collect(img.currentSrc || img.src || "");
						});
					document
						.querySelectorAll(
							'a[href*="/backend-api/estuary/content?id=file_"]',
						)
						.forEach((a) => {
							collect(a.href || "");
						});
				} catch (_) {
					/* ignore DOM access issues */
				}
				return out;
			})();

			data.__chatgptSignedImageUrls = Object.fromEntries(
				signedUrlByFileId.entries(),
			);

			const imageCacheByFileId = new Map();
			const mapping = data.mapping || {};
			const nodes = Object.values(mapping);
			const needsDownload = ImageOptions.needsDownload(cfg);

			for (const node of nodes) {
				const msg = node?.message;
				if (!msg || msg.author?.role !== "tool") continue;
				const content = msg.content;
				if (
					!content ||
					content.content_type !== "multimodal_text" ||
					!Array.isArray(content.parts)
				)
					continue;

				for (const part of content.parts) {
					if (!part || part.content_type !== "image_asset_pointer") continue;
					const ptr = String(part.asset_pointer || "");
					const fileIdMatch = ptr.match(/(file_[a-zA-Z0-9]+)/);
					const fileId = fileIdMatch ? fileIdMatch[1] : "";
					if (!fileId) continue;

					if (!imageCacheByFileId.has(fileId)) {
						const signedUrl = signedUrlByFileId.get(fileId) || "";
						const bareUrl = `${location.origin}/backend-api/estuary/content?id=${encodeURIComponent(fileId)}`;
						const resolvedUrl = signedUrl || bareUrl;

						if (needsDownload) {
							const fetchResult = await Utils.fetchImageData(resolvedUrl);
							if (fetchResult?.ok) {
								const ext = Utils.inferExtensionFromMime(
									fetchResult.contentType,
								);
								const guessedName = `${fileId}.${ext}`;
								const safeName = Utils.sanitizeFilesystemName(
									fetchResult.fileName || guessedName,
								);
								imageCacheByFileId.set(fileId, {
									fileId,
									signedUrl,
									bareUrl,
									resolvedUrl,
									blob: fetchResult.blob,
									dataUri: fetchResult.dataUri,
									fileName: safeName,
									contentType: fetchResult.contentType || "",
									fetchError: "",
								});
							} else {
								imageCacheByFileId.set(fileId, {
									fileId,
									signedUrl,
									bareUrl,
									resolvedUrl,
									blob: null,
									dataUri: "",
									fileName: `${fileId}.img`,
									contentType: "",
									fetchError: fetchResult?.error || "Download failed",
								});
							}
						} else {
							imageCacheByFileId.set(fileId, {
								fileId,
								signedUrl,
								bareUrl,
								resolvedUrl,
								blob: null,
								dataUri: "",
								fileName: `${fileId}.img`,
								contentType: "",
								fetchError: "",
							});
						}
					}

					part.__chatgptImage = imageCacheByFileId.get(fileId);
				}
			}

			return data;
		},

		generateMarkdown(data, settings = null) {
			const cfg = settings || CONFIG;
			console.log(
				"[Chat Exporter] ChatGPTProvider.generateMarkdown() using cfg.INCLUDE_USER_MESSAGES:",
				cfg.INCLUDE_USER_MESSAGES,
			);

			const title = Utils.sanitize(data.title, "ChatGPT_Export");
			const activeNodeId = data.current_node;
			const mapping = data.mapping || {};

			let md = `# ${title}\n\n`;

			if (cfg.INCLUDE_HEADER) {
				md += `> **Provider:** ChatGPT  \n`;
				if (data.create_time) {
					md += `> **Date:** ${new Date(data.create_time * 1000).toLocaleString()}  \n`;
				} else {
					md += `> **Date:** ${new Date().toLocaleString()}  \n`;
				}
				md += `> **Source:** [ChatGPT](${location.href})  \n`;
				if (cfg.INCLUDE_ACTIVE_LEAF_INFO && activeNodeId) {
					md += `> **Active Node:** \`${activeNodeId}\`  \n`;
				}
				md += `\n---\n\n`;
			}

			const getNodeTime = (node, fallback = 0) => {
				const t = node?.message?.create_time;
				return typeof t === "number" && Number.isFinite(t) ? t : fallback;
			};

			const isVisibleAssistantMessage = (msg) => {
				if (!msg || msg.author?.role !== "assistant") return false;
				const recipient = msg.recipient || "all";
				const channel = msg.channel ?? null;
				return recipient === "all" && (channel === null || channel === "final");
			};

			const signedImageUrlByFileId = (() => {
				const out = new Map();
				try {
					const fromData = data.__chatgptSignedImageUrls || {};
					Object.entries(fromData).forEach(([k, v]) => {
						if (k && v) out.set(k, String(v));
					});
				} catch (_) {
					/* ignore */
				}
				return out;
			})();

			const getChatGPTEstuaryUrl = (fileId) => {
				if (!fileId) return "";
				return (
					signedImageUrlByFileId.get(fileId) ||
					`${location.origin}/backend-api/estuary/content?id=${encodeURIComponent(fileId)}`
				);
			};

			// Turn-scoped image collector (reset at start of each turn, output at end)
			let turnImageParts = [];

			const rawTextFromContent = (content) => {
				if (!content || typeof content !== "object") return "";

				if (content.content_type === "text") {
					if (!Array.isArray(content.parts)) return "";
					const parts = content.parts.map((p) => {
						if (typeof p === "string") return p;
						if (p && typeof p === "object" && typeof p.text === "string")
							return p.text;
						return JSON.stringify(p);
					});
					return parts.join("\n");
				}

				if (content.content_type === "code") {
					return Utils.makeCodeFence(
						content.text || "",
						content.language || "unknown",
					);
				}

				if (content.content_type === "execution_output") {
					return Utils.makeCodeFence(content.text || "", "output");
				}

				if (content.content_type === "system_error") {
					return `> ⚠️ **System Error:** ${content.name || "Unknown error"}\n>\n> ${content.text || ""}`;
				}

				// ChatGPT "thoughts" (reasoning blocks) - skip empty, format non-empty
				if (content.content_type === "thoughts") {
					if (!Array.isArray(content.thoughts)) return "";
					// Extract all non-empty content from thoughts array
					const thoughtTexts = content.thoughts
						.map((t) => {
							const parts = [];
							if (t.summary) parts.push(t.summary);
							if (t.content) parts.push(t.content);
							return parts.join("\n\n");
						})
						.filter((text) => text?.trim());
					if (!thoughtTexts.length) return "";
					return Utils.formatThinkingBlock(thoughtTexts.join("\n\n"), cfg);
				}

				if (
					content.content_type === "multimodal_text" &&
					Array.isArray(content.parts)
				) {
					const wantsAnyImageOutput = ImageOptions.hasAny(cfg);
					const wantsVisualOrLink = !!(
						cfg.IMAGE_MD_RELATIVE_PATH ||
						cfg.IMAGE_MD_BASE64 ||
						cfg.IMAGE_MD_REMOTE_URL ||
						cfg.IMAGE_HTML_IMG_BASE64 ||
						cfg.IMAGE_HTML_IMG_REMOTE ||
						cfg.IMAGE_CLICKABLE_WEB_LINK
					);
					if (wantsAnyImageOutput && !wantsVisualOrLink) {
						// Download-only mode: no inline markdown output for image tool content.
						return "";
					}

					// Helper to render image markdown for a part
					const renderImagePart = (part) => {
						const ptr = String(part.asset_pointer || "");
						const fileIdMatch = ptr.match(/(file_[a-zA-Z0-9]+)/);
						const fileId = fileIdMatch ? fileIdMatch[1] : "";
						const imgMeta = part.__chatgptImage || {};
						const estuaryUrl =
							imgMeta.resolvedUrl ||
							(fileId ? getChatGPTEstuaryUrl(fileId) : "");
						const w = part.width || "?";
						const h = part.height || "?";
						const bytes = part.size_bytes
							? `${part.size_bytes} bytes`
							: "size unknown";

						const imageLines = [];
						imageLines.push(`> 🖼️ **Generated image:** ${w}x${h} (${bytes})`);

						let renderedAny = false;

						// ─── Markdown Inline ───
						if (
							cfg.IMAGE_MD_RELATIVE_PATH &&
							imgMeta.blob &&
							imgMeta.fileName
						) {
							imageLines.push(`![generated image](${imgMeta.fileName})`);
							imagesEmbedded++;
							renderedAny = true;
						}
						if (cfg.IMAGE_MD_BASE64 && imgMeta.dataUri) {
							imageLines.push(`![generated image](${imgMeta.dataUri})`);
							imagesEmbedded++;
							renderedAny = true;
						}
						if (cfg.IMAGE_MD_REMOTE_URL && estuaryUrl) {
							imageLines.push(`![generated image](${estuaryUrl})`);
							imagesEmbedded++;
							renderedAny = true;
						}

						// ─── HTML Inline ───
						if (cfg.IMAGE_HTML_IMG_BASE64 && imgMeta.dataUri) {
							imageLines.push(
								`<img src="${imgMeta.dataUri}" alt="generated image" />`,
							);
							imagesEmbedded++;
							renderedAny = true;
						}
						if (cfg.IMAGE_HTML_IMG_REMOTE && estuaryUrl) {
							imageLines.push(
								`<img src="${estuaryUrl}" alt="generated image" />`,
							);
							imagesEmbedded++;
							renderedAny = true;
						}

						// ─── Link ───
						if (cfg.IMAGE_CLICKABLE_WEB_LINK) {
							const linkTarget =
								estuaryUrl ||
								(imgMeta.blob && imgMeta.fileName ? imgMeta.fileName : "");
							if (linkTarget) {
								imageLines.push(`🔗 [Open image](${linkTarget})`);
								renderedAny = true;
							}
						}
						if (
							cfg.IMAGE_CLICKABLE_FILE_LINK &&
							imgMeta.blob &&
							imgMeta.fileName
						) {
							imageLines.push(
								`📎 [Open file: ${imgMeta.fileName}](${imgMeta.fileName})`,
							);
							renderedAny = true;
						}

						if (!renderedAny && ptr) {
							imageLines.push(`\`asset_pointer: ${ptr}\``);
						}

						if (ImageOptions.needsDownload(cfg) && imgMeta.fetchError) {
							imageLines.push(
								`> ℹ️ Image download failed: ${imgMeta.fetchError}`,
							);
						} else if (
							(cfg.IMAGE_MD_REMOTE_URL || cfg.IMAGE_CLICKABLE_WEB_LINK) &&
							fileId &&
							!signedImageUrlByFileId.get(fileId)
						) {
							imageLines.push(
								`> ℹ️ Signed URL not found in DOM; exported fallback URL.`,
							);
						}

						return imageLines.join("\n\n");
					};

					const lines = [];
					content.parts.forEach((part) => {
						if (!part || typeof part !== "object") return;
						if (part.content_type === "image_asset_pointer") {
							const imageMd = renderImagePart(part);
							// When COLLAPSIBLE_IMAGES is enabled, collect images separately
							if (cfg.COLLAPSIBLE_IMAGES) {
								turnImageParts.push(imageMd);
							} else {
								lines.push(imageMd);
							}
						} else if (typeof part.text === "string") {
							lines.push(part.text);
						} else {
							lines.push(JSON.stringify(part, null, 2));
						}
					});
					return lines.join("\n\n");
				}

				return "";
			};

			const canonicalizeUrl = (url) => {
				if (!url || typeof url !== "string") return "";
				try {
					const u = new URL(url);
					u.searchParams.delete("utm_source");
					return u.toString();
				} catch {
					return url;
				}
			};

			const collectMessageSources = (msg) => {
				const refs = Array.isArray(msg?.metadata?.content_references)
					? msg.metadata.content_references
					: [];

				const sources = [];
				const sourceIndexByCanonicalUrl = new Map();
				const mentions = [];

				const addSource = (title, url, sourceLabel = "") => {
					if (!url) return 0;
					const canonical = canonicalizeUrl(url);
					if (sourceIndexByCanonicalUrl.has(canonical)) {
						return sourceIndexByCanonicalUrl.get(canonical);
					}

					const cleanTitle = (title || url).replace(/\n/g, " ").trim();
					const cleanSource = (sourceLabel || "").replace(/\n/g, " ").trim();
					const idx = sources.length + 1;

					sources.push({
						title: cleanTitle,
						url,
						source: cleanSource,
					});
					sourceIndexByCanonicalUrl.set(canonical, idx);
					return idx;
				};

				refs.forEach((ref) => {
					if (!ref || typeof ref !== "object") return;

					if (ref.type === "grouped_webpages") {
						const nums = [];
						const items = Array.isArray(ref.items) ? ref.items : [];

						items.forEach((it) => {
							if (!it || typeof it !== "object") return;

							const mainNum = addSource(it.title, it.url, it.attribution || "");
							if (mainNum) nums.push(mainNum);

							const supporting = Array.isArray(it.supporting_websites)
								? it.supporting_websites
								: [];
							supporting.forEach((sw) => {
								const n = addSource(sw.title, sw.url, sw.attribution || "");
								if (n) nums.push(n);
							});
						});

						if (!nums.length && Array.isArray(ref.safe_urls)) {
							ref.safe_urls.forEach((url) => {
								const n = addSource(url, url, "");
								if (n) nums.push(n);
							});
						}

						const uniqueNums = [...new Set(nums)].sort((a, b) => a - b);
						if (
							typeof ref.start_idx === "number" &&
							typeof ref.end_idx === "number" &&
							uniqueNums.length
						) {
							mentions.push({
								start: ref.start_idx,
								end: ref.end_idx,
								numbers: uniqueNums,
								markerText:
									typeof ref.matched_text === "string" ? ref.matched_text : "",
							});
						}
					} else if (ref.type === "sources_footnote") {
						const listed = Array.isArray(ref.sources) ? ref.sources : [];
						listed.forEach((s) => {
							addSource(s?.title, s?.url, s?.attribution || "");
						});
					}
				});

				return { sources, mentions };
			};

			const applyCitations = (msg, rawText) => {
				let text = rawText || "";
				const { sources, mentions } = collectMessageSources(msg);

				if (
					cfg.INCLUDE_WEB_FEATURES &&
					cfg.INCLUDE_SOURCES &&
					mentions.length > 0
				) {
					const sorted = [...mentions].sort((a, b) => b.start - a.start);
					sorted.forEach((m) => {
						const citationLinks = m.numbers
							.map((num) => {
								const src = sources[num - 1];
								return src ? `[${num}](${src.url})` : "";
							})
							.filter(Boolean)
							.join("");
						const marker = citationLinks ? `<sup>${citationLinks}</sup>` : "";

						// Prefer exact marker replacement when available; offsets can drift.
						let replaced = false;
						if (m.markerText) {
							const posFromEnd = text.lastIndexOf(
								m.markerText,
								Math.max(
									0,
									Math.min(m.start + m.markerText.length, text.length),
								),
							);
							if (posFromEnd >= 0) {
								text =
									text.slice(0, posFromEnd) +
									marker +
									text.slice(posFromEnd + m.markerText.length);
								replaced = true;
							}
						}

						if (!replaced) {
							const start = Math.max(0, Math.min(m.start, text.length));
							const end = Math.max(start, Math.min(m.end, text.length));
							text = text.slice(0, start) + marker + text.slice(end);
						}
					});
				}

				if (cfg.INCLUDE_WEB_FEATURES && cfg.INCLUDE_SOURCES) {
					text = text
						.replace(
							/[\uE200-\uE202]cite[^\uE201]*\uE201/g,
							" <sup>[source]</sup> ",
						)
						.replace(/cite.*?/g, " <sup>[source]</sup> ");
				} else {
					text = text
						.replace(/[\uE200-\uE202]cite[^\uE201]*\uE201/g, " ")
						.replace(/cite.*?/g, " ");
				}

				// Defensive cleanup for partially replaced ChatGPT marker fragments
				// (prevents tofu symbols or dangling citation digits like "... </sup>2").
				text = text
					.replace(/<\/sup>\s*\d+\s*/g, "</sup>")
					.replace(/turn\d+search\d+/g, "")
					.replace(/turn\d+search\d+/g, "")
					.replace(/\d+/g, "")
					.replace(/[]/g, "");

				return { text, sources };
			};

			const flattenSearchResults = (msg) => {
				const groups = Array.isArray(msg?.metadata?.search_result_groups)
					? msg.metadata.search_result_groups
					: [];
				const results = [];
				groups.forEach((group) => {
					if (Array.isArray(group?.entries)) {
						results.push(...group.entries.filter((it) => it?.url));
					}
				});
				return results;
			};

			const renderToolIO = (
				title,
				inputLang,
				inputText,
				outputLang,
				outputText,
			) => {
				const bodyParts = [];
				if (inputText) {
					bodyParts.push(
						`**Input:**\n\n${Utils.makeCodeFence(inputText, inputLang || "")}`,
					);
				}
				if (outputText) {
					bodyParts.push(
						`**Output:**\n\n${Utils.makeCodeFence(outputText, outputLang || "")}`,
					);
				}
				if (!bodyParts.length) return;

				const body = bodyParts.join("\n\n");
				if (cfg.COLLAPSIBLE_TOOL_CALLS) {
					md += `<details>\n<summary><strong>${Utils.escapeHtml(title)}</strong></summary>\n\n${body}\n\n</details>\n\n`;
				} else {
					md += `**${title}**\n\n${body}\n\n`;
				}
			};

			const renderSearchData = (toolMsg) => {
				if (!cfg.INCLUDE_WEB_FEATURES) return;

				if (
					cfg.INCLUDE_SEARCH_QUERIES &&
					Array.isArray(toolMsg?.metadata?.search_model_queries?.queries)
				) {
					toolMsg.metadata.search_model_queries.queries.forEach((q) => {
						md += `🔍 *Searching:* \`${q}\`\n\n`;
					});
				}

				if (!cfg.INCLUDE_SEARCH_RESULTS) return;
				const searchResults = flattenSearchResults(toolMsg);
				if (!searchResults.length) return;

				if (cfg.COLLAPSIBLE_SEARCH_RESULTS) {
					md += `<details>\n<summary><strong>🔍 Search Results (${searchResults.length})</strong></summary>\n\n`;
					searchResults.forEach((it, idx) => {
						const t = (it.title || it.url).replace(/\n/g, " ").trim();
						md += `${idx + 1}. [${t}](${it.url})\n`;
					});
					md += `\n</details>\n\n`;
				} else {
					md += `**🔍 Search Results (${searchResults.length}):**\n\n`;
					searchResults.forEach((it, idx) => {
						const t = (it.title || it.url).replace(/\n/g, " ").trim();
						md += `${idx + 1}. [${t}](${it.url})\n`;
					});
					md += `\n`;
				}
			};

			const renderOperations = (ops) => {
				if (!Array.isArray(ops) || !ops.length) return;

				ops.forEach((op) => {
					const m = op?.message;
					if (!m || !m.author) return;

					const role = m.author.role;
					const toolName = (m.author.name || m.recipient || "tool").toString();

					if (role === "assistant") {
						if (!cfg.INCLUDE_TOOL_CALLS) return;
						const c = m.content || {};
						let inputRaw = "";
						if (c.content_type === "code") {
							inputRaw = c.text || "";
						} else if (c.content_type === "text" && Array.isArray(c.parts)) {
							inputRaw = c.parts
								.map((p) => {
									if (typeof p === "string") return p;
									if (p && typeof p === "object" && typeof p.text === "string")
										return p.text;
									return JSON.stringify(p);
								})
								.join("\n");
						} else {
							inputRaw = rawTextFromContent(c);
						}
						if (!inputRaw) return;

						let inputLang = "plaintext";
						if (c.content_type === "code") {
							inputLang = c.language || "unknown";
						} else if (c.content_type === "text") {
							inputLang = "text";
						}

						renderToolIO(`🛠️ ${toolName}`, inputLang, inputRaw, "", "");
						return;
					}

					if (role !== "tool") return;

					const c = m.content || {};
					const isImageOutput =
						c.content_type === "multimodal_text" &&
						Array.isArray(c.parts) &&
						c.parts.some((p) => p?.content_type === "image_asset_pointer");

					if (toolName === "web.run") {
						renderSearchData(m);
					}

					// Images should render even when tool calls are disabled.
					if (isImageOutput && ImageOptions.hasAny(cfg)) {
						const imageMd = rawTextFromContent(c);
						if (imageMd) {
							if (cfg.INCLUDE_TOOL_CALLS) {
								if (cfg.COLLAPSIBLE_TOOL_CALLS) {
									md += `<details>\n<summary><strong>${Utils.escapeHtml(`🛠️ ${toolName}`)}</strong></summary>\n\n**Output:**\n\n${imageMd}\n\n</details>\n\n`;
								} else {
									md += `**🛠️ ${toolName}**\n\n**Output:**\n\n${imageMd}\n\n`;
								}
							} else {
								md += `${imageMd}\n\n`;
							}
						}
						return;
					}

					if (!cfg.INCLUDE_TOOL_CALLS) return;

					let outputRaw = "";
					if (
						c.content_type === "execution_output" ||
						c.content_type === "code"
					) {
						outputRaw = c.text || "";
					} else if (c.content_type === "text" && Array.isArray(c.parts)) {
						outputRaw = c.parts
							.map((p) => {
								if (typeof p === "string") return p;
								if (p && typeof p === "object" && typeof p.text === "string")
									return p.text;
								return JSON.stringify(p);
							})
							.join("\n");
					} else {
						outputRaw = rawTextFromContent(c);
					}
					if (!outputRaw) {
						if (toolName !== "web.run") {
							md += `*(Tool execution: ${toolName})*\n\n`;
						}
						return;
					}

					let outputLang = "plaintext";
					if (c.content_type === "execution_output") outputLang = "output";
					else if (c.content_type === "code")
						outputLang = c.language || "unknown";
					else if (c.content_type === "text") outputLang = "text";

					renderToolIO(`🛠️ ${toolName}`, "", "", outputLang, outputRaw);
				});
			};

			const collectActivePathNodes = () => {
				if (!activeNodeId || !mapping[activeNodeId]) return [];
				const chain = [];
				let cur = activeNodeId;
				while (cur && mapping[cur]) {
					const node = mapping[cur];
					if (node.message?.author && node.message.author.role !== "system") {
						chain.push(node);
					}
					cur = node.parent;
				}
				chain.reverse();
				return chain;
			};

			const collectAllTreeNodes = () => {
				const allIds = Object.keys(mapping);
				const visited = new Set();
				const out = [];

				const sortIds = (ids, parentNode = null) => {
					return [...ids].sort((a, b) => {
						const ta = getNodeTime(mapping[a], getNodeTime(parentNode));
						const tb = getNodeTime(mapping[b], getNodeTime(parentNode));
						if (ta !== tb) return ta - tb;
						return String(a).localeCompare(String(b));
					});
				};

				const visit = (id, _parentNode = null) => {
					if (!id || visited.has(id) || !mapping[id]) return;
					visited.add(id);

					const node = mapping[id];
					const msg = node.message;
					if (msg?.author && msg.author.role !== "system") {
						out.push(node);
					}

					const children = Array.isArray(node.children) ? node.children : [];
					for (const childId of sortIds(children, node)) visit(childId, node);
				};

				const roots = allIds.filter((id) => {
					const n = mapping[id];
					return !n || !n.parent || !mapping[n.parent];
				});

				for (const rootId of sortIds(roots)) visit(rootId, null);

				// Include any disconnected leftovers.
				const leftovers = allIds.filter((id) => !visited.has(id));
				for (const leftId of sortIds(leftovers)) visit(leftId, null);

				return out;
			};

			const rawNodes = cfg.EXPORT_ALL_REGENERATIONS
				? collectAllTreeNodes()
				: collectActivePathNodes();

			// Normalize internal tool plumbing into assistant turns.
			const normalizedTurns = [];
			let pendingOps = [];

			const flushPendingAsAssistant = () => {
				if (!pendingOps.length) return;
				const fallbackAssistant =
					[...pendingOps]
						.reverse()
						.find((op) => op?.message?.author?.role === "assistant") || null;
				normalizedTurns.push({
					type: "assistant",
					message: fallbackAssistant ? fallbackAssistant.message : null,
					operations: [...pendingOps],
					synthesized: true,
				});
				pendingOps = [];
			};

			rawNodes.forEach((node) => {
				const msg = node?.message;
				if (!msg || !msg.author) return;
				const role = msg.author.role;

				if (role === "user") {
					flushPendingAsAssistant();
					normalizedTurns.push({
						type: "user",
						message: msg,
						operations: [],
						synthesized: false,
					});
					return;
				}

				if (role === "assistant") {
					if (isVisibleAssistantMessage(msg)) {
						normalizedTurns.push({
							type: "assistant",
							message: msg,
							operations: [...pendingOps],
							synthesized: false,
						});
						pendingOps = [];
					} else {
						pendingOps.push({ message: msg });
					}
					return;
				}

				if (role === "tool") {
					pendingOps.push({ message: msg });
				}
			});

			flushPendingAsAssistant();

			let turnNumber = 0;
			let exportedCount = 0;
			let imagesEmbedded = 0;

			normalizedTurns.forEach((turn) => {
				const isUser = turn.type === "user";
				if (isUser && !cfg.INCLUDE_USER_MESSAGES) return;
				if (!isUser && !cfg.INCLUDE_ASSISTANT_MESSAGES) return;

				const msg = turn.message;
				const timestampMsg =
					msg ||
					turn.operations.find((op) => op?.message?.create_time)?.message ||
					null;
				const idMsg =
					msg || turn.operations.find((op) => op?.message?.id)?.message || null;

				// Reset image collector for this turn
				turnImageParts = [];

				// Pre-check: skip entirely if assistant turn has no meaningful content
				if (!isUser) {
					const preCheckText = msg ? rawTextFromContent(msg.content) : "";
					const hasImages = turn.operations.some((op) => {
						const c = op?.message?.content || {};
						return (
							c.content_type === "multimodal_text" &&
							Array.isArray(c.parts) &&
							c.parts.some((p) => p?.content_type === "image_asset_pointer") &&
							ImageOptions.hasAny(cfg)
						);
					});
					// Skip if no text, no images, and no other tool outputs
					if (!preCheckText && !hasImages && !turn.operations.length) {
						return;
					}
				}

				turnNumber++;
				exportedCount++;

				let roleHeader = isUser ? "USER" : "CHATGPT";
				if (cfg.INCLUDE_TURN_NUMBERS) {
					roleHeader = `[${turnNumber}] ${roleHeader}`;
				}
				if (!isUser && cfg.INCLUDE_MODEL_INFO && msg?.metadata?.model_slug) {
					roleHeader += ` (${msg.metadata.model_slug})`;
				}

				if (cfg.COLLAPSIBLE_MESSAGES) {
					md += `<details>\n<summary><strong>${Utils.escapeHtml(roleHeader)}</strong></summary>\n\n`;
				} else {
					md += `## ${roleHeader}\n\n`;
				}

				if (cfg.INCLUDE_TIMESTAMPS && timestampMsg?.create_time) {
					md += `*${new Date(timestampMsg.create_time * 1000).toLocaleString()}*\n\n`;
				}

				if (cfg.INCLUDE_MESSAGE_IDS && idMsg?.id) {
					md += `\`ID: ${idMsg.id}\`\n\n`;
				}

				if (isUser) {
					let userText = rawTextFromContent(msg?.content);
					userText = Utils.processCodeBlocks(userText, cfg);
					if (userText) {
						md += `${userText}\n\n`;
					}
				} else {
					let assistantText = msg ? rawTextFromContent(msg.content) : "";
					let sources = [];

					if (msg?.content?.content_type === "text") {
						const cited = applyCitations(msg, assistantText);
						assistantText = cited.text;
						sources = cited.sources;
					}

					// Keep tool activity inline with the turn flow (closer to DOM behavior).
					renderOperations(turn.operations);

					// Avoid duplicated tool-call JSON in synthesized turns:
					// the same payload is already shown in the tool Input block.
					const isRecipientTool = !!(msg?.recipient && msg.recipient !== "all");
					if (turn.synthesized && isRecipientTool) {
						assistantText = "";
					}

					assistantText = Utils.processCodeBlocks(assistantText, cfg);
					if (assistantText) {
						md += `${assistantText}\n\n`;
					}

					if (
						cfg.INCLUDE_WEB_FEATURES &&
						cfg.INCLUDE_SOURCES_LIST &&
						sources.length > 0
					) {
						if (cfg.COLLAPSIBLE_SOURCES_LIST) {
							md += `<details>\n<summary><strong>📚 Sources (${sources.length})</strong></summary>\n\n`;
							sources.forEach((source, idx) => {
								const t = (source.title || source.url)
									.replace(/\n/g, " ")
									.trim();
								const s = source.source ? ` — ${source.source}` : "";
								md += `${idx + 1}. [${t}](${source.url})${s}\n`;
							});
							md += `\n</details>\n\n`;
						} else {
							md += `**📚 Sources (${sources.length}):**\n\n`;
							sources.forEach((source, idx) => {
								const t = (source.title || source.url)
									.replace(/\n/g, " ")
									.trim();
								const s = source.source ? ` — ${source.source}` : "";
								md += `${idx + 1}. [${t}](${source.url})${s}\n`;
							});
							md += `\n`;
						}
					}
				}

				// Output collected images for this turn (if any)
				if (turnImageParts.length > 0) {
					const imageBody = turnImageParts.join("\n\n");
					if (cfg.COLLAPSIBLE_IMAGES) {
						md += `<details>\n<summary><strong>🖼️ Images (${turnImageParts.length})</strong></summary>\n\n${imageBody}\n\n</details>\n\n`;
					} else {
						md += `${imageBody}\n\n`;
					}
				}

				if (cfg.COLLAPSIBLE_MESSAGES) {
					md += `</details>\n\n---\n\n`;
				} else {
					md += `---\n\n`;
				}
			});

			return {
				content: md,
				filename: `${Utils.sanitizeFilename(title, "ChatGPT_Export")}.md`,
				stats: {
					total: normalizedTurns.length,
					exported: exportedCount,
					imagesEmbedded: imagesEmbedded,
				},
			};
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// PROVIDER REGISTRY
	// ═══════════════════════════════════════════════════════════════════════════
	const Providers = {
		list: [ChatGPTProvider, ClaudeProvider, GrokProvider, ArenaProvider],

		detect() {
			const url = location.href;
			return this.list.find((p) => p.matches(url)) || null;
		},

		getCurrent() {
			return this.detect();
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// STATE
	// ═══════════════════════════════════════════════════════════════════════════
	const State = {
		error: null,
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// SETTINGS PANEL (Shadow DOM Isolated)
	// ═══════════════════════════════════════════════════════════════════════════
	const PANEL_STYLES = `
        :host {
            all: initial;
        }
        * {
            box-sizing: border-box;
        }
        .settings-panel {
            position: fixed;
            background: #1f2937;
            border: 1px solid #374151;
            border-radius: 12px;
            font-family: system-ui, -apple-system, sans-serif;
            font-size: 13px;
            color: #e5e7eb;
            box-shadow: 0 8px 24px rgba(0,0,0,0.4);
            min-width: 260px;
            max-width: 320px;
            user-select: none;
            pointer-events: auto;
            z-index: 2147483647;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .settings-panel .header {
            flex-shrink: 0;
            padding: 10px 16px;
            background: #111827;
            border-bottom: 1px solid #374151;
            border-radius: 12px 12px 0 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .settings-panel .header-title {
            font-weight: 600;
            font-size: 14px;
            color: #f9fafb;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .settings-panel .header-title .provider-badge {
            background: #22c55e;
            color: #fff;
            font-size: 10px;
            font-weight: 600;
            padding: 2px 6px;
            border-radius: 4px;
            text-transform: uppercase;
        }
        .settings-panel .close-button {
            width: 24px;
            height: 24px;
            border: none;
            background: transparent;
            color: #9ca3af;
            font-size: 18px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            padding: 0;
            line-height: 1;
            transition: all 0.15s;
        }
        .settings-panel .close-button:hover {
            background: #374151;
            color: #f9fafb;
        }
        .settings-panel .content {
            flex: 1;
            overflow-y: auto;
            padding: 16px;
        }
        .settings-panel .content::-webkit-scrollbar {
            width: 6px;
        }
        .settings-panel .content::-webkit-scrollbar-track {
            background: #374151;
            border-radius: 3px;
        }
        .settings-panel .content::-webkit-scrollbar-thumb {
            background: #6b7280;
            border-radius: 3px;
        }
        .settings-panel .group {
            margin-bottom: 12px;
        }
        .settings-panel .group:last-child {
            margin-bottom: 0;
        }
        .settings-panel .group-title {
            font-size: 10px;
            font-weight: 600;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
            padding-bottom: 4px;
            border-bottom: 1px solid #374151;
        }
        .settings-panel .subsection-title {
            font-size: 9px;
            font-weight: 500;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-top: 10px;
            margin-bottom: 4px;
            padding-left: 0;
        }
        .settings-panel .subsection-title.indent {
            padding-left: 20px;
            font-size: 10px;
        }
        .settings-panel label {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 5px 0;
            cursor: pointer;
            transition: color 0.15s;
        }
        .settings-panel label:hover {
            color: #60a5fa;
        }
        .settings-panel label.indent {
            padding-left: 20px;
            font-size: 12px;
            color: #9ca3af;
        }
        .settings-panel label.indent:hover {
            color: #60a5fa;
        }
        .settings-panel label.indent-2 {
            padding-left: 40px;
            font-size: 11px;
            color: #6b7280;
        }
        .settings-panel label.indent-2:hover {
            color: #60a5fa;
        }
        .settings-panel label.disabled {
            color: #6b7280;
        }
        .settings-panel label.disabled input[type="checkbox"] {
            opacity: 0.4;
            pointer-events: none;
        }
        .settings-panel label[data-tooltip] {
            position: relative;
        }
        .settings-panel label[data-tooltip]::after {
            content: attr(data-tooltip);
            position: absolute;
            visibility: hidden;
            opacity: 0;
            background: #111827;
            color: #d1d5db;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 11px;
            line-height: 1.4;
            max-width: 220px;
            width: max-content;
            white-space: pre-line;
            z-index: 100;
            left: 0;
            bottom: calc(100% + 6px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.4);
            border: 1px solid #374151;
            pointer-events: none;
            transition: opacity 0.15s ease-in-out, visibility 0.15s ease-in-out;
            transition-delay: 0s;
        }
        .settings-panel label[data-tooltip]:hover::after {
            visibility: visible;
            opacity: 1;
            transition-delay: 0.2s;
        }
        .settings-panel input[type="checkbox"] {
            width: 16px;
            height: 16px;
            cursor: pointer;
            accent-color: #22c55e;
            flex-shrink: 0;
        }
        .settings-panel .footer {
            flex-shrink: 0;
            padding: 12px 16px;
            border-top: 1px solid #374151;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            background: #1f2937;
        }
        .settings-panel .kofi-button {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            background: #22c55e;
            color: #fff;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.15s, transform 0.1s;
        }
        .settings-panel .kofi-button:hover {
            background: #16a34a;
            transform: translateY(-1px);
        }
        .settings-panel .reset-button {
            background: transparent;
            border: 1px solid #374151;
            color: #9ca3af;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.15s;
        }
        .settings-panel .reset-button:hover {
            background: #374151;
            color: #f9fafb;
            border-color: #4b5563;
        }

    `;

	const SettingsPanel = {
		shadowHost: null,
		shadowRoot: null,
		panel: null,
		isOpen: false,
		currentProvider: null,
		checkboxRefs: {},
		closeHandler: null,
		escapeHandler: null,

		init() {
			console.log("[Chat Exporter] SettingsPanel.init() called");

			if (this.shadowHost) {
				console.log("[Chat Exporter] Shadow host already exists");
				return;
			}

			this.shadowHost = document.createElement("div");
			this.shadowHost.id = "chat-export-settings-host";
			Object.assign(this.shadowHost.style, {
				position: "fixed",
				top: "0",
				left: "0",
				width: "0",
				height: "0",
				overflow: "visible",
				zIndex: CONFIG.Z_INDEX.toString(),
				pointerEvents: "none",
			});

			this.shadowRoot = this.shadowHost.attachShadow({ mode: "closed" });
			console.log("[Chat Exporter] Shadow root created");

			const style = document.createElement("style");
			style.textContent = PANEL_STYLES;
			this.shadowRoot.appendChild(style);

			document.body.appendChild(this.shadowHost);
			console.log("[Chat Exporter] Shadow host appended to body");
		},

		buildPanel(providerName) {
			console.log("[Chat Exporter] buildPanel() for:", providerName);

			// Remove existing panel if any
			if (this.panel) {
				console.log("[Chat Exporter] Removing existing panel");
				this.panel.remove();
				this.panel = null;
			}
			this.checkboxRefs = {};

			const flags = PROVIDER_FLAGS[providerName] || [];
			console.log("[Chat Exporter] Flags for provider:", flags.length, flags);

			if (flags.length === 0) {
				console.warn(
					"[Chat Exporter] No flags defined for provider:",
					providerName,
				);
				return null;
			}

			this.panel = document.createElement("div");
			this.panel.className = "settings-panel";

			// Header (fixed at top)
			const header = document.createElement("div");
			header.className = "header";

			const headerTitle = document.createElement("div");
			headerTitle.className = "header-title";
			headerTitle.innerHTML = `Export Settings <span class="provider-badge">${providerName}</span>`;

			const closeButton = document.createElement("button");
			closeButton.className = "close-button";
			closeButton.textContent = "✕";
			closeButton.addEventListener("click", (e) => {
				e.stopPropagation();
				this.hide();
			});

			header.appendChild(headerTitle);
			header.appendChild(closeButton);
			this.panel.appendChild(header);

			// Content container (scrollable)
			const content = document.createElement("div");
			content.className = "content";

			// Group flags by their group, then by subsection
			const groupedFlags = {};
			flags.forEach((flagName) => {
				const meta = FLAG_METADATA[flagName];
				if (!meta) return;
				const group = meta.group || "Other";
				const subsection = meta.subsection || "";
				if (!groupedFlags[group]) groupedFlags[group] = {};
				if (!groupedFlags[group][subsection])
					groupedFlags[group][subsection] = [];
				groupedFlags[group][subsection].push({ name: flagName, ...meta });
			});

			// Render groups in order
			FLAG_GROUP_ORDER.forEach((groupName) => {
				const groupSubsections = groupedFlags[groupName];
				if (!groupSubsections || Object.keys(groupSubsections).length === 0)
					return;

				const groupDiv = document.createElement("div");
				groupDiv.className = "group";

				const groupTitle = document.createElement("div");
				groupTitle.className = "group-title";
				groupTitle.textContent = groupName;
				groupDiv.appendChild(groupTitle);

				// Get subsection order for this group
				const subsectionOrder = FLAG_SUBSECTION_ORDER[groupName] || [""];

				// Render subsections in order
				subsectionOrder.forEach((subsectionName) => {
					const subsectionFlags = groupSubsections[subsectionName];
					if (!subsectionFlags || subsectionFlags.length === 0) return;

					// Add subsection header if named (indented to align with sub-options)
					if (subsectionName) {
						const subsectionDiv = document.createElement("div");
						subsectionDiv.className = "subsection-title indent";
						subsectionDiv.textContent = subsectionName;
						groupDiv.appendChild(subsectionDiv);
					}

					subsectionFlags.forEach((flag) => {
						// Resolve provider-specific label
						let labelText = flag.label;
						if (typeof flag.label === "object") {
							labelText =
								flag.label[providerName] ||
								flag.label.ChatGPT ||
								flag.label.Claude ||
								flag.label.Grok ||
								flag.name;
						}

						// Handle provider-specific tooltips
						let tooltipText = "";
						if (flag.tooltip) {
							tooltipText = flag.tooltip;
							if (typeof flag.tooltip === "object") {
								tooltipText =
									flag.tooltip[providerName] ||
									flag.tooltip.ChatGPT ||
									flag.tooltip.Claude ||
									flag.tooltip.Grok ||
									"";
							}
						}

						const label = document.createElement("label");
						if (flag.indent) label.classList.add("indent");
						if (flag.extraIndent) label.classList.add("indent-2");

						if (tooltipText) {
							label.setAttribute("data-tooltip", tooltipText);
						}

						const checkbox = document.createElement("input");
						checkbox.type = "checkbox";
						checkbox.id = `setting-${flag.name}`;
						checkbox.checked = Settings.get(providerName, flag.name);

						checkbox.addEventListener("change", (e) => {
							e.stopPropagation();
							const newValue = checkbox.checked;
							console.log(
								"[Chat Exporter] Setting changed:",
								flag.name,
								"=",
								newValue,
							);
							Settings.save(providerName, flag.name, newValue);

							// Master toggle logic: handle INCLUDE_IMAGES, INCLUDE_WEB_FEATURES, INCLUDE_WIDGETS
							this.handleMasterToggle(providerName, flag.name, newValue);

							this.updateDependentStates(providerName);
						});

						const text = document.createTextNode(labelText);
						label.appendChild(checkbox);
						label.appendChild(text);
						groupDiv.appendChild(label);

						this.checkboxRefs[flag.name] = { checkbox, label };
					});
				});

				content.appendChild(groupDiv);
			});

			this.panel.appendChild(content);

			// Footer with Ko-Fi button and reset button (fixed at bottom)
			const footer = document.createElement("div");
			footer.className = "footer";

			const kofiLink = document.createElement("a");
			kofiLink.className = "kofi-button";
			kofiLink.href = "https://ko-fi.com/piknockyou";
			kofiLink.target = "_blank";
			kofiLink.rel = "noopener noreferrer";
			kofiLink.title = "Support this script on Ko-Fi";
			kofiLink.textContent = "☕ Support";
			kofiLink.addEventListener("click", (e) => {
				e.stopPropagation();
			});

			const resetButton = document.createElement("button");
			resetButton.className = "reset-button";
			resetButton.textContent = "Reset to Defaults";
			resetButton.addEventListener("click", (e) => {
				e.stopPropagation();
				console.log("[Chat Exporter] Resetting settings for:", providerName);
				Settings.reset(providerName);
				this.refreshCheckboxes(providerName);
			});

			footer.appendChild(kofiLink);
			footer.appendChild(resetButton);
			this.panel.appendChild(footer);

			// Block event propagation through panel
			this.panel.addEventListener("mousedown", (e) => e.stopPropagation());
			this.panel.addEventListener("mouseup", (e) => e.stopPropagation());
			this.panel.addEventListener("click", (e) => e.stopPropagation());

			this.shadowRoot.appendChild(this.panel);
			this.updateDependentStates(providerName);

			return this.panel;
		},

		updateDependentStates(providerName) {
			// Disable dependent checkboxes when parent is unchecked
			const settings = Settings.load(providerName);

			// COLLAPSIBLE_THINKING depends on INCLUDE_THINKING
			if (this.checkboxRefs.COLLAPSIBLE_THINKING) {
				const enabled = settings.INCLUDE_THINKING;
				this.checkboxRefs.COLLAPSIBLE_THINKING.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.COLLAPSIBLE_THINKING.checkbox.disabled = !enabled;
			}

			// COLLAPSIBLE_ATTACHMENTS depends on INCLUDE_ATTACHMENTS
			if (this.checkboxRefs.COLLAPSIBLE_ATTACHMENTS) {
				const enabled = settings.INCLUDE_ATTACHMENTS;
				this.checkboxRefs.COLLAPSIBLE_ATTACHMENTS.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.COLLAPSIBLE_ATTACHMENTS.checkbox.disabled = !enabled;
			}

			// CLAUDE_EMBED_FILES_V2_CONTENT depends on INCLUDE_ATTACHMENTS
			if (this.checkboxRefs.CLAUDE_EMBED_FILES_V2_CONTENT) {
				const enabled = settings.INCLUDE_ATTACHMENTS;
				this.checkboxRefs.CLAUDE_EMBED_FILES_V2_CONTENT.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.CLAUDE_EMBED_FILES_V2_CONTENT.checkbox.disabled =
					!enabled;
			}

			// COLLAPSIBLE_ARTIFACTS depends on INCLUDE_ARTIFACTS
			if (this.checkboxRefs.COLLAPSIBLE_ARTIFACTS) {
				const enabled = settings.INCLUDE_ARTIFACTS;
				this.checkboxRefs.COLLAPSIBLE_ARTIFACTS.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.COLLAPSIBLE_ARTIFACTS.checkbox.disabled = !enabled;
			}

			// COLLAPSIBLE_SEARCH_RESULTS depends on INCLUDE_SEARCH_RESULTS
			if (this.checkboxRefs.COLLAPSIBLE_SEARCH_RESULTS) {
				const enabled = settings.INCLUDE_SEARCH_RESULTS;
				this.checkboxRefs.COLLAPSIBLE_SEARCH_RESULTS.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.COLLAPSIBLE_SEARCH_RESULTS.checkbox.disabled =
					!enabled;
			}

			// COLLAPSIBLE_SOURCES_LIST depends on INCLUDE_SOURCES_LIST
			if (this.checkboxRefs.COLLAPSIBLE_SOURCES_LIST) {
				const enabled = settings.INCLUDE_SOURCES_LIST;
				this.checkboxRefs.COLLAPSIBLE_SOURCES_LIST.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.COLLAPSIBLE_SOURCES_LIST.checkbox.disabled = !enabled;
			}

			// COLLAPSIBLE_CODE_BLOCKS depends on INCLUDE_CODE_BLOCKS
			if (this.checkboxRefs.COLLAPSIBLE_CODE_BLOCKS) {
				const enabled = settings.INCLUDE_CODE_BLOCKS;
				this.checkboxRefs.COLLAPSIBLE_CODE_BLOCKS.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.COLLAPSIBLE_CODE_BLOCKS.checkbox.disabled = !enabled;
			}

			// COLLAPSIBLE_TOOL_CALLS depends on INCLUDE_TOOL_CALLS
			if (this.checkboxRefs.COLLAPSIBLE_TOOL_CALLS) {
				const enabled = settings.INCLUDE_TOOL_CALLS;
				this.checkboxRefs.COLLAPSIBLE_TOOL_CALLS.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.COLLAPSIBLE_TOOL_CALLS.checkbox.disabled = !enabled;
			}

			// INCLUDE_ACTIVE_LEAF_INFO depends on INCLUDE_HEADER
			if (this.checkboxRefs.INCLUDE_ACTIVE_LEAF_INFO) {
				const enabled = settings.INCLUDE_HEADER;
				this.checkboxRefs.INCLUDE_ACTIVE_LEAF_INFO.label.classList.toggle(
					"disabled",
					!enabled,
				);
				this.checkboxRefs.INCLUDE_ACTIVE_LEAF_INFO.checkbox.disabled = !enabled;
			}

			// Widget sub-options depend on INCLUDE_WIDGETS
			const widgetDeps = [
				"WIDGET_MD_RELATIVE_PATH",
				"WIDGET_MD_BASE64",
				"WIDGET_MD_DATAURI_TEXT",
				"WIDGET_HTML_SVG_RAW",
				"WIDGET_HTML_IMG_BASE64",
				"WIDGET_HTML_IMG_DATAURI",
				"WIDGET_CLICKABLE_LINK",
				"COLLAPSIBLE_WIDGETS",
			];
			for (const dep of widgetDeps) {
				if (this.checkboxRefs[dep]) {
					const enabled = settings.INCLUDE_WIDGETS;
					this.checkboxRefs[dep].label.classList.toggle("disabled", !enabled);
					this.checkboxRefs[dep].checkbox.disabled = !enabled;
				}
			}

			// WIDGET_CLICKABLE_LINK requires relative path (user must download SVG manually)
			if (this.checkboxRefs.WIDGET_CLICKABLE_LINK) {
				const hasFileTarget = settings.WIDGET_MD_RELATIVE_PATH;
				const parentEnabled = settings.INCLUDE_WIDGETS;
				this.checkboxRefs.WIDGET_CLICKABLE_LINK.label.classList.toggle(
					"disabled",
					!parentEnabled || !hasFileTarget,
				);
				this.checkboxRefs.WIDGET_CLICKABLE_LINK.checkbox.disabled =
					!parentEnabled || !hasFileTarget;
			}

			// COLLAPSIBLE_WIDGETS requires at least one inline option (not link - that's not inline content)
			if (this.checkboxRefs.COLLAPSIBLE_WIDGETS) {
				const hasInlineContent = !!(
					settings.WIDGET_MD_RELATIVE_PATH ||
					settings.WIDGET_MD_BASE64 ||
					settings.WIDGET_MD_DATAURI_TEXT ||
					settings.WIDGET_HTML_SVG_RAW ||
					settings.WIDGET_HTML_IMG_BASE64 ||
					settings.WIDGET_HTML_IMG_DATAURI
				);
				const parentEnabled = settings.INCLUDE_WIDGETS;
				this.checkboxRefs.COLLAPSIBLE_WIDGETS.label.classList.toggle(
					"disabled",
					!parentEnabled || !hasInlineContent,
				);
				this.checkboxRefs.COLLAPSIBLE_WIDGETS.checkbox.disabled =
					!parentEnabled || !hasInlineContent;
			}

			// COLLAPSIBLE_IMAGES requires at least one image option enabled
			if (this.checkboxRefs.COLLAPSIBLE_IMAGES) {
				const hasImageContent = !!(
					settings.IMAGE_DOWNLOAD_FILES ||
					settings.IMAGE_MD_RELATIVE_PATH ||
					settings.IMAGE_MD_BASE64 ||
					settings.IMAGE_MD_REMOTE_URL ||
					settings.IMAGE_HTML_IMG_BASE64 ||
					settings.IMAGE_HTML_IMG_REMOTE ||
					settings.IMAGE_CLICKABLE_WEB_LINK ||
					settings.IMAGE_CLICKABLE_FILE_LINK
				);
				const parentEnabled = settings.INCLUDE_IMAGES;
				this.checkboxRefs.COLLAPSIBLE_IMAGES.label.classList.toggle(
					"disabled",
					!parentEnabled || !hasImageContent,
				);
				this.checkboxRefs.COLLAPSIBLE_IMAGES.checkbox.disabled =
					!parentEnabled || !hasImageContent;
			}

			// Image sub-options depend on INCLUDE_IMAGES master toggle
			const imageDeps = [
				"IMAGE_DOWNLOAD_FILES",
				"IMAGE_MD_RELATIVE_PATH",
				"IMAGE_MD_BASE64",
				"IMAGE_MD_REMOTE_URL",
				"IMAGE_HTML_IMG_BASE64",
				"IMAGE_HTML_IMG_REMOTE",
				"IMAGE_CLICKABLE_WEB_LINK",
				"IMAGE_CLICKABLE_FILE_LINK",
				"COLLAPSIBLE_IMAGES",
			];
			for (const dep of imageDeps) {
				if (this.checkboxRefs[dep]) {
					const enabled = settings.INCLUDE_IMAGES;
					this.checkboxRefs[dep].label.classList.toggle("disabled", !enabled);
					this.checkboxRefs[dep].checkbox.disabled = !enabled;
				}
			}

			// IMAGE_CLICKABLE_WEB_LINK only needs master toggle - URL is always available from API
			if (this.checkboxRefs.IMAGE_CLICKABLE_WEB_LINK) {
				const parentEnabled = settings.INCLUDE_IMAGES;
				this.checkboxRefs.IMAGE_CLICKABLE_WEB_LINK.label.classList.toggle(
					"disabled",
					!parentEnabled,
				);
				this.checkboxRefs.IMAGE_CLICKABLE_WEB_LINK.checkbox.disabled =
					!parentEnabled;
			}

			// IMAGE_CLICKABLE_FILE_LINK requires a file to link to
			if (this.checkboxRefs.IMAGE_CLICKABLE_FILE_LINK) {
				const hasFileTarget =
					settings.IMAGE_DOWNLOAD_FILES || settings.IMAGE_MD_RELATIVE_PATH;
				const parentEnabled = settings.INCLUDE_IMAGES;
				this.checkboxRefs.IMAGE_CLICKABLE_FILE_LINK.label.classList.toggle(
					"disabled",
					!parentEnabled || !hasFileTarget,
				);
				this.checkboxRefs.IMAGE_CLICKABLE_FILE_LINK.checkbox.disabled =
					!parentEnabled || !hasFileTarget;
			}

			// Web search sub-options depend on INCLUDE_WEB_FEATURES master toggle
			const webDeps = [
				"INCLUDE_SEARCH_QUERIES",
				"INCLUDE_SEARCH_RESULTS",
				"COLLAPSIBLE_SEARCH_RESULTS",
				"INCLUDE_SOURCES",
				"INCLUDE_SOURCES_LIST",
				"COLLAPSIBLE_SOURCES_LIST",
			];
			for (const dep of webDeps) {
				if (this.checkboxRefs[dep]) {
					const enabled = settings.INCLUDE_WEB_FEATURES;
					this.checkboxRefs[dep].label.classList.toggle("disabled", !enabled);
					this.checkboxRefs[dep].checkbox.disabled = !enabled;
				}
			}
		},

		// Master-to-sub-option mappings
		_masterToggleMap: {
			INCLUDE_IMAGES: [
				"IMAGE_DOWNLOAD_FILES",
				"IMAGE_MD_RELATIVE_PATH",
				"IMAGE_MD_BASE64",
				"IMAGE_MD_REMOTE_URL",
				"IMAGE_HTML_IMG_BASE64",
				"IMAGE_HTML_IMG_REMOTE",
				"IMAGE_CLICKABLE_WEB_LINK",
				"IMAGE_CLICKABLE_FILE_LINK",
				"COLLAPSIBLE_IMAGES",
			],
			INCLUDE_WEB_FEATURES: [
				"INCLUDE_SEARCH_QUERIES",
				"INCLUDE_SEARCH_RESULTS",
				"COLLAPSIBLE_SEARCH_RESULTS",
				"INCLUDE_SOURCES",
				"INCLUDE_SOURCES_LIST",
				"COLLAPSIBLE_SOURCES_LIST",
			],
			INCLUDE_WIDGETS: [
				"WIDGET_MD_RELATIVE_PATH",
				"WIDGET_MD_BASE64",
				"WIDGET_MD_DATAURI_TEXT",
				"WIDGET_HTML_SVG_RAW",
				"WIDGET_HTML_IMG_BASE64",
				"WIDGET_HTML_IMG_DATAURI",
				"WIDGET_CLICKABLE_LINK",
				"COLLAPSIBLE_WIDGETS",
			],
		},

		// Saved state for restoration when master is toggled back on
		_savedSubOptions: {},

		/**
		 * Handle master toggle changes:
		 * - When OFF: save current sub-options, then uncheck all
		 * - When ON: if all sub-options are off, restore saved or apply defaults
		 */
		handleMasterToggle(providerName, flagName, newValue) {
			const subOptions = this._masterToggleMap[flagName];
			if (!subOptions) return; // Not a master toggle

			const settings = Settings.load(providerName);

			if (!newValue) {
				// Master turned OFF: save current states, then uncheck all
				this._savedSubOptions[flagName] = {};
				subOptions.forEach((opt) => {
					this._savedSubOptions[flagName][opt] = settings[opt];
					if (this.checkboxRefs[opt]) {
						this.checkboxRefs[opt].checkbox.checked = false;
						Settings.save(providerName, opt, false);
					}
				});
				this.refreshCheckboxes(providerName);
			} else {
				// Master turned ON: check if all sub-options are off
				const hasAnyOn = subOptions.some((opt) => settings[opt]);
				if (!hasAnyOn) {
					// All off: restore saved state or apply defaults
					const saved = this._savedSubOptions[flagName];
					subOptions.forEach((opt) => {
						let value;
						if (saved && saved[opt] !== undefined) {
							// Restore saved state
							value = saved[opt];
						} else {
							// Apply CONFIG default
							value = CONFIG[opt];
						}
						if (this.checkboxRefs[opt]) {
							this.checkboxRefs[opt].checkbox.checked = value;
							Settings.save(providerName, opt, value);
						}
					});
					this.refreshCheckboxes(providerName);
				}
			}
		},

		refreshCheckboxes(providerName) {
			const settings = Settings.load(providerName);
			Object.keys(this.checkboxRefs).forEach((flagName) => {
				const ref = this.checkboxRefs[flagName];
				if (ref?.checkbox) {
					ref.checkbox.checked = settings[flagName];
				}
			});
			this.updateDependentStates(providerName);
		},

		/**
		 * Calculate the best position for the panel that keeps it fully visible.
		 * Hard rule: never go off-screen (top/bottom/left/right).
		 * Behavior: prefer the placement that provides the MOST vertical space.
		 */
		calculateBestPosition(anchorRect, panelWidth) {
			const vw = window.innerWidth;
			const vh = window.innerHeight;
			const margin = 8;
			const minHeight = 150;

			// Available height within viewport bounds
			const fullHeight = vh - 2 * margin;

			// Available height above/below button while preserving margins
			const availAbove = anchorRect.top - 2 * margin;
			const availBelow = vh - anchorRect.bottom - 2 * margin;

			// Available width left/right of button while preserving margins
			const availRight = vw - anchorRect.right - 2 * margin;
			const availLeft = anchorRect.left - 2 * margin;

			const clampLeft = (left) =>
				Math.max(margin, Math.min(left, vw - panelWidth - margin));

			// Align right edge of panel with right edge of anchor, clamped
			const alignedLeft = clampLeft(anchorRect.right - panelWidth);

			const candidates = [];

			// Right of button (full height)
			if (availRight >= panelWidth && fullHeight >= minHeight) {
				candidates.push({
					kind: "right",
					left: anchorRect.right + margin,
					top: margin,
					height: fullHeight,
					pref: 2,
				});
			}

			// Left of button (full height)
			if (availLeft >= panelWidth && fullHeight >= minHeight) {
				candidates.push({
					kind: "left",
					left: anchorRect.left - margin - panelWidth,
					top: margin,
					height: fullHeight,
					pref: 1,
				});
			}

			// Below button (max available below)
			if (availBelow >= minHeight) {
				candidates.push({
					kind: "below",
					left: alignedLeft,
					top: anchorRect.bottom + margin,
					height: availBelow,
					pref: 4,
				});
			}

			// Above button (max available above)
			if (availAbove >= minHeight) {
				candidates.push({
					kind: "above",
					left: alignedLeft,
					top: margin,
					height: availAbove,
					pref: 3,
				});
			}

			// Fallback: overlay (full height)
			if (candidates.length === 0) {
				candidates.push({
					kind: "overlay",
					left: clampLeft((vw - panelWidth) / 2),
					top: margin,
					height: Math.max(minHeight, fullHeight),
					pref: 0,
				});
			}

			// Score: prioritize height, then preference
			candidates.sort((a, b) => {
				if (a.height !== b.height) return b.height - a.height;
				return b.pref - a.pref;
			});

			return candidates[0];
		},

		show(anchorElement, providerName) {
			console.log(
				"[Chat Exporter] SettingsPanel.show() called for:",
				providerName,
			);

			if (!this.shadowHost) {
				console.log("[Chat Exporter] Initializing shadow host...");
				this.init();
			}

			if (!document.body.contains(this.shadowHost)) {
				console.log("[Chat Exporter] Re-appending shadow host to body");
				document.body.appendChild(this.shadowHost);
			}

			this.currentProvider = providerName;
			console.log("[Chat Exporter] Building panel...");
			this.buildPanel(providerName);

			if (!this.panel) {
				console.warn(
					"[Chat Exporter] No flags available for provider:",
					providerName,
				);
				return;
			}

			// Get button position and calculate best panel position
			const rect = anchorElement.getBoundingClientRect();
			const vw = window.innerWidth;
			const vh = window.innerHeight;
			const margin = 8;

			// Force a deterministic width that can never overflow the viewport
			const panelWidth = Math.max(220, Math.min(320, vw - 2 * margin));

			const pos = this.calculateBestPosition(rect, panelWidth);
			console.log("[Chat Exporter] Best position calculated:", pos);

			// Apply size - width fixed, height fits content up to max
			this.panel.style.width = `${panelWidth}px`;
			this.panel.style.maxWidth = `${panelWidth}px`;
			this.panel.style.minWidth = "0px";

			// Height: fit content, with max based on available space
			const maxH = Math.max(150, Math.min(pos.height, vh - 2 * margin));
			this.panel.style.height = "auto";
			this.panel.style.maxHeight = `${maxH}px`;

			// Apply horizontal position
			this.panel.style.left = `${Math.max(margin, Math.min(pos.left, vw - panelWidth - margin))}px`;
			this.panel.style.right = "auto";

			// Apply vertical position based on placement kind
			// Hard rule: never go off-screen. Also avoid "floating away" from the button.
			const setTop = (t) => {
				this.panel.style.top = `${Math.max(margin, Math.min(t, vh - margin))}px`;
				this.panel.style.bottom = "auto";
			};
			const setBottom = (b) => {
				this.panel.style.bottom = `${Math.max(margin, Math.min(b, vh - margin))}px`;
				this.panel.style.top = "auto";
			};

			if (pos.kind === "below") {
				// Keep it adjacent to the button
				setTop(rect.bottom + margin);
			} else if (pos.kind === "above") {
				// Keep it adjacent to the button (above)
				setBottom(vh - rect.top + margin);
			} else if (pos.kind === "left" || pos.kind === "right") {
				// Side placement: align near the button, but clamp to stay visible.
				setTop(rect.top);

				// Measure after maxHeight is applied so we can clamp precisely
				const h = this.panel.getBoundingClientRect().height;

				// If it would overflow at the bottom, try aligning the panel's bottom to the button's bottom
				if (rect.top + h + margin > vh) {
					setBottom(vh - rect.bottom + margin);

					// If that pushed it off-screen at the top, fall back to top margin
					if (this.panel.getBoundingClientRect().top < margin) {
						setTop(margin);
					}
				} else {
					// Otherwise, clamp top so the whole panel is visible, staying as close as possible to the button
					const clampedTop = Math.max(
						margin,
						Math.min(rect.top, vh - h - margin),
					);
					setTop(clampedTop);
				}
			} else {
				// overlay fallback
				setTop(margin);
			}

			this.isOpen = true;
			console.log("[Chat Exporter] Panel is now open, isOpen:", this.isOpen);

			// Close handlers
			if (this.closeHandler) {
				document.removeEventListener("mousedown", this.closeHandler, true);
			}

			this.closeHandler = (e) => {
				if (!this.isOpen) return;
				const path = e.composedPath();
				if (path.includes(this.shadowHost)) return;
				if (e.target === anchorElement || anchorElement.contains(e.target))
					return;
				this.hide();
			};

			this.escapeHandler = (e) => {
				if (e.key === "Escape" && this.isOpen) {
					this.hide();
				}
			};

			setTimeout(() => {
				document.addEventListener("mousedown", this.closeHandler, true);
				document.addEventListener("keydown", this.escapeHandler, true);
			}, 50);
		},

		hide() {
			if (this.panel) {
				this.panel.remove();
				this.panel = null;
			}
			this.isOpen = false;
			this.currentProvider = null;
			this.checkboxRefs = {};

			if (this.closeHandler) {
				document.removeEventListener("mousedown", this.closeHandler, true);
				this.closeHandler = null;
			}
			if (this.escapeHandler) {
				document.removeEventListener("keydown", this.escapeHandler, true);
				this.escapeHandler = null;
			}
		},

		toggle(anchorElement, providerName) {
			console.log(
				"[Chat Exporter] SettingsPanel.toggle() - isOpen:",
				this.isOpen,
				"currentProvider:",
				this.currentProvider,
				"requested:",
				providerName,
			);

			if (this.isOpen && this.currentProvider === providerName) {
				console.log(
					"[Chat Exporter] Panel already open for this provider, hiding...",
				);
				this.hide();
			} else {
				console.log("[Chat Exporter] Opening panel...");
				this.hide(); // Close any existing panel first
				this.show(anchorElement, providerName);
			}
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// FAVICON LOADER (CSP Bypass via GM_xmlhttpRequest)
	// ═══════════════════════════════════════════════════════════════════════════
	const FaviconLoader = {
		cache: {},

		/**
		 * Fetch a favicon URL and convert to base64 data URI.
		 * Uses GM_xmlhttpRequest to bypass CSP restrictions.
		 */
		fetchAsBase64(url) {
			return new Promise((resolve) => {
				// Check cache first
				if (this.cache[url]) {
					resolve(this.cache[url]);
					return;
				}

				try {
					GM_xmlhttpRequest({
						method: "GET",
						url: url,
						responseType: "blob",
						timeout: 5000,
						onload: (response) => {
							if (response.status !== 200) {
								resolve(null);
								return;
							}
							const reader = new FileReader();
							reader.onload = () => {
								const base64 = reader.result;
								this.cache[url] = base64;
								resolve(base64);
							};
							reader.onerror = () => resolve(null);
							reader.readAsDataURL(response.response);
						},
						onerror: () => resolve(null),
						ontimeout: () => resolve(null),
					});
				} catch (_e) {
					resolve(null);
				}
			});
		},

		/**
		 * Load favicon into an img element, bypassing CSP.
		 */
		async load(imgElement, url, fallbackText) {
			const base64 = await this.fetchAsBase64(url);
			if (base64) {
				imgElement.src = base64;
			} else {
				// Fallback: show first letter
				imgElement.style.display = "none";
				const parent = imgElement.parentElement;
				if (parent) {
					const fallback = document.createElement("span");
					fallback.textContent = fallbackText || "?";
					fallback.style.cssText =
						"font-size: 18px; font-weight: bold; color: #fff;";
					parent.appendChild(fallback);
				}
			}
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// ONBOARDING BANNER (First-run hint)
	// ═══════════════════════════════════════════════════════════════════════════
	//
	// DRY design:
	//   - Single style injector (idempotent)
	//   - Declarative content sections
	//   - Provider icons specified as data, loaded via FaviconLoader
	//
	const OnboardingBanner = {
		element: null,
		closeHandler: null,

		// Single source of truth for banner content
		CONTENT: {
			title: { icon: "📥", text: "Multi-Provider Chat Exporter" },
			controls: [
				{
					icon: "🖱️",
					strong: "Left-click",
					text: "Export conversation to Markdown",
				},
				{ icon: "⚙️", strong: "Right-click", text: "Open settings panel" },
				{ icon: "✋", strong: "Right-drag", text: "Move button anywhere" },
			],
			providers: [
				{
					id: "chatgpt",
					name: "ChatGPT",
					favicon: "https://chatgpt.com/favicon.ico",
					fallbackText: "GPT",
				},
				{
					id: "claude",
					name: "Claude.ai",
					favicon: "https://claude.ai/favicon.ico",
					fallbackText: "C",
				},
				{
					id: "grok",
					name: "Grok.com",
					favicon:
						"https://www.google.com/s2/favicons?sz=64&domain=aistudio.google.com",
					fallbackText: "G",
				},
				{
					id: "arena",
					name: "Arena.ai",
					favicon: "https://arena.ai/favicon.ico",
					fallbackText: "L",
				},
			],
			features: [
				"User & Assistant Messages",
				"Turn Numbers",
				"Thinking/Reasoning Blocks",
				"Code Blocks",
				"File Attachments",
				"Artifacts",
				"Web Search Queries",
				"Search Results",
				"Inline Citations",
				"Sources Bibliography",
				"Collapsible Sections",
				"Model Names",
				"Timestamps",
				"Message IDs",
				"Regenerations/Branches",
				"Active Leaf/Node/Response ID",
			],
			footer: {
				checkboxId: "onboarding-dismiss-forever",
				checkboxText: "Don't show again",
				buttonText: "Got it!",
			},
		},

		STYLES_ID: "chat-export-onboarding-styles",
		BANNER_ID: "chat-export-onboarding",

		isDismissed() {
			// Use GM storage for cross-domain persistence
			return GM_getValue(CONFIG.HINT_DISMISSED_KEY, false) === true;
		},

		dismiss(permanent = false) {
			if (permanent) {
				GM_setValue(CONFIG.HINT_DISMISSED_KEY, true);
			}
			if (this.element) {
				this.element.style.opacity = "0";
				this.element.style.transform = "translateY(10px)";
				setTimeout(() => {
					this.element?.remove();
					this.element = null;
				}, 200);
			}
			if (this.closeHandler) {
				document.removeEventListener("mousedown", this.closeHandler);
				this.closeHandler = null;
			}
		},

		injectStyles() {
			if (document.getElementById(this.STYLES_ID)) return;

			const style = document.createElement("style");
			style.id = this.STYLES_ID;
			style.textContent = `
                #${this.BANNER_ID} {
                    position: fixed;
                    background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
                    color: #fff;
                    padding: 16px 20px;
                    border-radius: 12px;
                    font-family: system-ui, -apple-system, sans-serif;
                    font-size: 13px;
                    z-index: ${CONFIG.Z_INDEX - 1};
                    box-shadow: 0 8px 32px rgba(0,0,0,0.35), 0 0 0 1px rgba(255,255,255,0.1) inset;
                    line-height: 1.6;
                    max-width: 340px;
                    opacity: 0;
                    transform: translateY(10px);
                    transition: opacity 0.3s ease-out, transform 0.3s ease-out;
                }
                #${this.BANNER_ID}.visible {
                    opacity: 1;
                    transform: translateY(0);
                }
                #${this.BANNER_ID}.arrow-bottom::after {
                    content: '';
                    position: absolute;
                    bottom: -10px;
                    border-left: 12px solid transparent;
                    border-right: 12px solid transparent;
                    border-top: 12px solid #3b82f6;
                }
                #${this.BANNER_ID}.arrow-left::after { left: 24px; }
                #${this.BANNER_ID}.arrow-right::after { right: 24px; }
                #${this.BANNER_ID}.arrow-top::after {
                    content: '';
                    position: absolute;
                    top: -10px;
                    border-left: 12px solid transparent;
                    border-right: 12px solid transparent;
                    border-bottom: 12px solid #1e40af;
                }
                #${this.BANNER_ID} .hint-title {
                    font-weight: 700;
                    font-size: 15px;
                    margin-bottom: 14px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding-bottom: 12px;
                    border-bottom: 1px solid rgba(255,255,255,0.15);
                }
                #${this.BANNER_ID} .hint-title-icon {
                    font-size: 20px;
                }
                #${this.BANNER_ID} .hint-section {
                    margin-bottom: 14px;
                }
                #${this.BANNER_ID} .hint-section:last-of-type {
                    margin-bottom: 0;
                }
                #${this.BANNER_ID} .hint-section-title {
                    font-weight: 600;
                    font-size: 10px;
                    text-transform: uppercase;
                    letter-spacing: 0.8px;
                    opacity: 0.75;
                    margin-bottom: 8px;
                }
                #${this.BANNER_ID} .hint-list {
                    margin: 0;
                    padding: 0;
                    list-style: none;
                }
                #${this.BANNER_ID} .hint-list li {
                    padding: 4px 0;
                    display: flex;
                    align-items: flex-start;
                    gap: 10px;
                    font-size: 12.5px;
                }
                #${this.BANNER_ID} .hint-list-icon {
                    opacity: 0.8;
                    flex-shrink: 0;
                    width: 16px;
                    text-align: center;
                }
                #${this.BANNER_ID} .hint-list strong {
                    color: #bfdbfe;
                }
                #${this.BANNER_ID} .hint-providers {
                    display: flex;
                    gap: 16px;
                    align-items: center;
                    justify-content: center;
                    padding: 8px 0;
                }
                #${this.BANNER_ID} .hint-provider-icon {
                    position: relative;
                    width: 32px;
                    height: 32px;
                    background: rgba(255,255,255,0.15);
                    border-radius: 8px;
                    padding:  6px;
                    transition: all 0.2s ease;
                    cursor: help;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                #${this.BANNER_ID} .hint-provider-icon:hover {
                    background: rgba(255,255,255,0.25);
                    transform: translateY(-2px);
                }
                #${this.BANNER_ID} .hint-provider-icon img {
                    width: 100%;
                    height: 100%;
                    display: block;
                    border-radius: 4px;
                }
                #${this.BANNER_ID} .hint-provider-icon::after {
                    content: attr(data-name);
                    position: absolute;
                    bottom: calc(100% + 8px);
                    left: 50%;
                    transform: translateX(-50%);
                    background: #0f172a;
                    color: #f1f5f9;
                    padding: 6px 12px;
                    border-radius: 6px;
                    font-size: 11px;
                    font-weight: 600;
                    white-space: nowrap;
                    opacity: 0;
                    visibility: hidden;
                    transition: opacity 0.2s ease, visibility 0.2s ease;
                    pointer-events: none;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.4);
                }
                #${this.BANNER_ID} .hint-provider-icon:hover::after {
                    opacity: 1;
                    visibility: visible;
                }
                #${this.BANNER_ID} .hint-settings-preview {
                    font-size: 11.5px;
                    opacity: 0.9;
                    line-height: 1.6;
                }
                #${this.BANNER_ID} .hint-settings-grid {
                    display: grid;
                    grid-template-columns: repeat(2, 1fr);
                    gap: 6px 12px;
                    margin-top: 8px;
                }
                #${this.BANNER_ID} .hint-settings-item {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    font-size: 11px;
                }
                #${this.BANNER_ID} .hint-settings-item::before {
                    content: '✓';
                    color: #93c5fd;
                    font-weight: bold;
                    flex-shrink: 0;
                }
                #${this.BANNER_ID} .hint-footer {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-top: 16px;
                    padding-top: 14px;
                    border-top: 1px solid rgba(255,255,255,0.15);
                }
                #${this.BANNER_ID} .hint-checkbox-label {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    font-size: 11.5px;
                    opacity: 0.85;
                    cursor: pointer;
                    user-select: none;
                    transition: opacity 0.15s;
                }
                #${this.BANNER_ID} .hint-checkbox-label:hover {
                    opacity: 1;
                }
                #${this.BANNER_ID} .hint-checkbox-label input {
                    cursor: pointer;
                    accent-color: #93c5fd;
                    width: 14px;
                    height: 14px;
                }
                #${this.BANNER_ID} .hint-close {
                    background: rgba(255,255,255,0.2);
                    border: none;
                    color: #fff;
                    padding: 8px 20px;
                    border-radius: 6px;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: background 0.15s, transform 0.1s;
                }
                #${this.BANNER_ID} .hint-close:hover {
                    background: rgba(255,255,255,0.3);
                }
                #${this.BANNER_ID} .hint-close:active {
                    transform: scale(0.97);
                }
            `;
			document.head.appendChild(style);
		},

		buildHtml() {
			const c = this.CONTENT;

			const controlsHtml = c.controls
				.map(
					(item) =>
						`<li><span class="hint-list-icon">${item.icon}</span><span><strong>${item.strong}</strong> — ${item.text}</span></li>`,
				)
				.join("");

			const providersHtml = c.providers
				.map(
					(p) =>
						`<div class="hint-provider-icon" data-name="${Utils.escapeHtml(p.name)}">` +
						`<img id="onboarding-icon-${p.id}" src="" alt="${Utils.escapeHtml(p.name)}">` +
						`</div>`,
				)
				.join("");

			const featuresHtml = c.features
				.map(
					(f) => `<div class="hint-settings-item">${Utils.escapeHtml(f)}</div>`,
				)
				.join("");

			return `
                <div class="hint-title">
                    <span class="hint-title-icon">${c.title.icon}</span>
                    <span>${Utils.escapeHtml(c.title.text)}</span>
                </div>

                <div class="hint-section">
                    <div class="hint-section-title">Button Controls</div>
                    <ul class="hint-list">
                        ${controlsHtml}
                    </ul>
                </div>

                <div class="hint-section">
                    <div class="hint-section-title">Supported Providers</div>
                    <div class="hint-providers">
                        ${providersHtml}
                    </div>
                </div>

                <div class="hint-section">
                    <div class="hint-section-title">Configurable Per Provider — Right-Click to Customize</div>
                    <div class="hint-settings-preview">
                        <div class="hint-settings-grid">
                            ${featuresHtml}
                        </div>
                    </div>
                </div>

                <div class="hint-footer">
                    <label class="hint-checkbox-label">
                        <input type="checkbox" id="${c.footer.checkboxId}">
                        ${Utils.escapeHtml(c.footer.checkboxText)}
                    </label>
                    <button class="hint-close">${Utils.escapeHtml(c.footer.buttonText)}</button>
                </div>
            `;
		},

		show(anchorEl) {
			if (this.isDismissed()) return;
			if (this.element) return;
			if (!anchorEl) return;

			this.injectStyles();

			const hint = document.createElement("div");
			hint.id = this.BANNER_ID;

			hint.innerHTML = this.buildHtml();

			document.body.appendChild(hint);
			this.element = hint;

			// Position hint relative to button
			const btnRect = anchorEl.getBoundingClientRect();
			const hintWidth = 340;
			const hintHeight = hint.offsetHeight;
			const margin = 16;
			const vw = window.innerWidth;
			const vh = window.innerHeight;

			// Determine if button is in top or bottom half
			const buttonInTopHalf = btnRect.top < vh / 2;
			// Determine if button is in left or right half
			const buttonInLeftHalf = btnRect.left < vw / 2;

			let top, left;
			let arrowVertical = "bottom";
			const arrowHorizontal = buttonInLeftHalf ? "left" : "right";

			if (buttonInTopHalf) {
				// Position below button
				top = btnRect.bottom + margin;
				arrowVertical = "top";
			} else {
				// Position above button
				top = btnRect.top - hintHeight - margin;
				arrowVertical = "bottom";
			}

			if (buttonInLeftHalf) {
				// Align left edges
				left = Math.max(margin, btnRect.left - 10);
			} else {
				// Align right edges
				left = Math.min(
					vw - hintWidth - margin,
					btnRect.right - hintWidth + 10,
				);
			}

			// Clamp to viewport
			top = Math.max(margin, Math.min(top, vh - hintHeight - margin));
			left = Math.max(margin, Math.min(left, vw - hintWidth - margin));

			hint.style.top = `${top}px`;
			hint.style.left = `${left}px`;
			hint.classList.add(`arrow-${arrowVertical}`, `arrow-${arrowHorizontal}`);

			// Animate in
			requestAnimationFrame(() => {
				requestAnimationFrame(() => {
					hint.classList.add("visible");
				});
			});

			// Load favicons via CSP bypass (data-driven)
			this.CONTENT.providers.forEach((p) => {
				const img = hint.querySelector(`#onboarding-icon-${p.id}`);
				if (img) FaviconLoader.load(img, p.favicon, p.fallbackText);
			});

			// Event handlers
			const checkbox = hint.querySelector(`#${this.CONTENT.footer.checkboxId}`);
			const closeBtn = hint.querySelector(".hint-close");

			const close = () => this.dismiss(checkbox?.checked || false);

			closeBtn.addEventListener("click", (e) => {
				e.stopPropagation();
				close();
			});

			// Close on outside click
			this.closeHandler = (e) => {
				if (
					!hint.contains(e.target) &&
					e.target !== anchorEl &&
					!anchorEl.contains(e.target)
				) {
					close();
				}
			};

			setTimeout(() => {
				document.addEventListener("mousedown", this.closeHandler);
			}, 300);
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// UI COMPONENTS (Hardened: Shadow DOM icon + DOM re-attachment watchdog)
	// ═══════════════════════════════════════════════════════════════════════════
	const UI = {
		btn: null,
		shadowRoot: null,
		watchdogTimer: null,

		isDragging: false,
		isExporting: false,
		dragMoved: false,

		ensureInDOM() {
			if (!this.btn) return;
			if (!document.body) return;

			if (!document.body.contains(this.btn)) {
				document.body.appendChild(this.btn);
			}
		},

		startWatchdog() {
			if (this.watchdogTimer) return;

			this.watchdogTimer = setInterval(() => {
				if (!this.btn) return;
				if (!document.body) return;

				if (!document.body.contains(this.btn)) {
					console.log("[Chat Exporter] Watchdog: Re-attaching export button");
					document.body.appendChild(this.btn);
				}
			}, 2000);
		},

		init() {
			// If already initialized, just ensure it stays attached
			if (this.btn) {
				this.ensureInDOM();
				this.update();
				this.startWatchdog();
				return;
			}

			const btn = document.createElement("div");
			btn.id = "chat-export-btn";

			Object.assign(btn.style, {
				position: "fixed",
				width: `${CONFIG.BUTTON_SIZE}px`,
				height: `${CONFIG.BUTTON_SIZE}px`,
				borderRadius: "50%",
				boxShadow: "0 4px 12px rgba(0,0,0,0.3)",
				display: "none",
				alignItems: "center",
				justifyContent: "center",
				cursor: "pointer",
				zIndex: CONFIG.Z_INDEX,
				userSelect: "none",
				transition: "background-color 0.2s, transform 0.1s, opacity 0.2s",
				color: "#fff",
			});

			// Encapsulate the SVG icon inside a closed Shadow DOM.
			// The host element (btn) stays the clickable surface, preserving existing logic
			// and preventing Shadow DOM retargeting issues with SettingsPanel close logic.
			try {
				const shadow = btn.attachShadow({ mode: "closed" });
				this.shadowRoot = shadow;

				const style = document.createElement("style");
				style.textContent = `
                    :host { all: initial; }
                    svg { pointer-events: none; }
                `;
				shadow.appendChild(style);

				const SVG_NS = "http://www.w3.org/2000/svg";

				const svg = document.createElementNS(SVG_NS, "svg");
				svg.setAttribute("viewBox", "0 0 24 24");
				svg.setAttribute("width", "24");
				svg.setAttribute("height", "24");
				svg.setAttribute("stroke", "currentColor");
				svg.setAttribute("stroke-width", "2");
				svg.setAttribute("fill", "none");
				svg.setAttribute("stroke-linecap", "round");
				svg.setAttribute("stroke-linejoin", "round");

				const path = document.createElementNS(SVG_NS, "path");
				path.setAttribute("d", "M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4");
				svg.appendChild(path);

				const polyline = document.createElementNS(SVG_NS, "polyline");
				polyline.setAttribute("points", "7 10 12 15 17 10");
				svg.appendChild(polyline);

				const line = document.createElementNS(SVG_NS, "line");
				line.setAttribute("x1", "12");
				line.setAttribute("y1", "15");
				line.setAttribute("x2", "12");
				line.setAttribute("y2", "3");
				svg.appendChild(line);

				shadow.appendChild(svg);
			} catch (_e) {
				// Fallback: if Shadow DOM is unavailable for any reason, keep the old behavior.
				btn.innerHTML = `<svg viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>`;
			}

			this.loadPosition(btn);

			// Left-click: Export
			btn.addEventListener("click", (e) => {
				console.log(
					"[Chat Exporter] Left-click detected, isDragging:",
					this.isDragging,
				);
				if (e.button === 0 && !this.isDragging) this.export();
			});

			// Right-click: Settings (if no drag) or Drag
			btn.addEventListener("contextmenu", (e) => {
				e.preventDefault();
				e.stopPropagation();
				e.stopImmediatePropagation();
				console.log(
					"[Chat Exporter] Context menu event, dragMoved:",
					this.dragMoved,
				);

				// If we didn't drag, show settings
				if (!this.dragMoved) {
					const provider = Providers.getCurrent();
					console.log("[Chat Exporter] Provider for settings:", provider?.name);
					if (provider) {
						console.log(
							"[Chat Exporter] Toggling settings panel for:",
							provider.name,
						);
						SettingsPanel.toggle(btn, provider.name);
					} else {
						console.warn("[Chat Exporter] No provider detected!");
					}
				} else {
					console.log("[Chat Exporter] Drag detected, skipping settings panel");
				}

				// Reset dragMoved for next interaction
				this.dragMoved = false;
			});

			btn.addEventListener("mousedown", (e) => {
				console.log("[Chat Exporter] Mousedown, button:", e.button);
				if (e.button === 2) {
					e.preventDefault();
					this.dragMoved = false;
					this.startDrag(e);
				}
			});

			document.body.appendChild(btn);
			this.btn = btn;

			window.addEventListener("resize", () => this.applyPosition());
			this.update();
			this.startWatchdog();

			// Show first-run onboarding banner after a short delay
			setTimeout(() => {
				if (this.btn && this.btn.style.display !== "none") {
					OnboardingBanner.show(this.btn);
				}
			}, 1200);
		},

		loadPosition(btn) {
			const provider = Providers.getCurrent();
			const key =
				CONFIG.POSITION_STORAGE_PREFIX + (provider?.name || "default");
			const saved = GM_getValue(key, null);
			if (saved) {
				try {
					const pos = typeof saved === "string" ? JSON.parse(saved) : saved;
					this.setPosition(btn, pos.ratioX, pos.ratioY);
				} catch (_e) {
					// Default: bottom-left corner
					this.setPosition(btn, 0, 1);
				}
			} else {
				// Default: bottom-left corner
				this.setPosition(btn, 0, 1);
			}
		},

		setPosition(btn, rx, ry) {
			const maxX = window.innerWidth - CONFIG.BUTTON_SIZE;
			const maxY = window.innerHeight - CONFIG.BUTTON_SIZE;
			btn.style.left = `${Math.max(0, rx * maxX)}px`;
			btn.style.top = `${Math.max(0, ry * maxY)}px`;
		},

		applyPosition() {
			if (!this.btn) return;
			this.ensureInDOM();

			const provider = Providers.getCurrent();
			const key =
				CONFIG.POSITION_STORAGE_PREFIX + (provider?.name || "default");
			const saved = GM_getValue(key, null);
			if (saved) {
				try {
					const pos = typeof saved === "string" ? JSON.parse(saved) : saved;
					this.setPosition(this.btn, pos.ratioX, pos.ratioY);
				} catch (_e) {
					/* ignore */
				}
			}
		},

		startDrag(e) {
			if (!this.btn) return;
			this.ensureInDOM();

			this.isDragging = true;
			const rect = this.btn.getBoundingClientRect();
			const startX = e.clientX;
			const startY = e.clientY;
			const offX = e.clientX - rect.left;
			const offY = e.clientY - rect.top;

			const onMove = (ev) => {
				const dx = Math.abs(ev.clientX - startX);
				const dy = Math.abs(ev.clientY - startY);

				// Only start visual drag if moved more than 5px
				if (dx > 5 || dy > 5) {
					this.dragMoved = true;
					this.btn.style.cursor = "grabbing";
				}

				if (this.dragMoved) {
					const x = Math.max(
						0,
						Math.min(window.innerWidth - CONFIG.BUTTON_SIZE, ev.clientX - offX),
					);
					const y = Math.max(
						0,
						Math.min(
							window.innerHeight - CONFIG.BUTTON_SIZE,
							ev.clientY - offY,
						),
					);
					this.btn.style.left = `${x}px`;
					this.btn.style.top = `${y}px`;
				}
			};

			const onUp = () => {
				this.btn.style.cursor = "pointer";
				document.removeEventListener("mousemove", onMove);
				document.removeEventListener("mouseup", onUp);

				if (this.dragMoved) {
					const finalRect = this.btn.getBoundingClientRect();
					const maxX = window.innerWidth - CONFIG.BUTTON_SIZE;
					const maxY = window.innerHeight - CONFIG.BUTTON_SIZE;
					const rx = maxX > 0 ? finalRect.left / maxX : 0.95;
					const ry = maxY > 0 ? finalRect.top / maxY : 0.85;
					const provider = Providers.getCurrent();
					const key =
						CONFIG.POSITION_STORAGE_PREFIX + (provider?.name || "default");
					GM_setValue(key, { ratioX: rx, ratioY: ry });
				}

				setTimeout(() => {
					this.isDragging = false;
					// dragMoved is reset on next mousedown
				}, 50);
			};

			document.addEventListener("mousemove", onMove);
			document.addEventListener("mouseup", onUp);
		},

		update() {
			if (!this.btn) return;
			this.ensureInDOM();

			const provider = Providers.getCurrent();

			if (this.isExporting) {
				this.btn.style.backgroundColor = CONFIG.BUTTON_COLOR_LOADING;
				this.btn.title = "Exporting...";
			} else if (State.error) {
				this.btn.style.backgroundColor = CONFIG.BUTTON_COLOR_ERROR;
				this.btn.title = `Error: ${State.error || "Unknown"}. Click to retry.`;
			} else {
				this.btn.style.backgroundColor = CONFIG.BUTTON_COLOR_READY;
				this.btn.title = `Export to Markdown (${provider?.name || "Unknown"})\nLeft-click: Export\nRight-click: Settings\nRight-drag: Move`;
			}
		},

		async export() {
			const provider = Providers.getCurrent();
			if (!provider) return this.toast("Unknown provider");

			const chatId = provider.extractChatId(location.href);
			if (!chatId) return this.toast("Open a chat first");

			// Close settings panel if open
			SettingsPanel.hide();

			this.isExporting = true;
			this.update();
			this.toast(`Fetching ${provider.name} data...`);

			try {
				const providerSettings = Settings.load(provider.name);
				console.log(
					"[Chat Exporter] Export starting for provider:",
					provider.name,
				);
				console.log("[Chat Exporter] Exporting with settings:", {
					INCLUDE_USER_MESSAGES: providerSettings.INCLUDE_USER_MESSAGES,
					INCLUDE_ASSISTANT_MESSAGES:
						providerSettings.INCLUDE_ASSISTANT_MESSAGES,
					INCLUDE_THINKING: providerSettings.INCLUDE_THINKING,
					INCLUDE_HEADER: providerSettings.INCLUDE_HEADER,
				});

				const data = await provider.fetchChat(chatId, providerSettings);

				// Widget capture dialog (Claude only)
				// Only show if INCLUDE_WIDGETS + at least one embedding format that needs cached SVG data.
				// CLICKABLE_LINK doesn't need cache (user downloads manually).
				// COLLAPSIBLE_WIDGETS is just a wrapper, requires inline content.
				const hasWidgetEmbeddingFormat = !!(
					providerSettings.WIDGET_MD_RELATIVE_PATH ||
					providerSettings.WIDGET_MD_BASE64 ||
					providerSettings.WIDGET_MD_DATAURI_TEXT ||
					providerSettings.WIDGET_HTML_SVG_RAW ||
					providerSettings.WIDGET_HTML_IMG_BASE64 ||
					providerSettings.WIDGET_HTML_IMG_DATAURI
				);
				if (
					provider.name === "Claude" &&
					providerSettings.INCLUDE_WIDGETS &&
					hasWidgetEmbeddingFormat
				) {
					const widgetTitles = [];
					const messages = Array.isArray(data?.chat_messages)
						? data.chat_messages
						: [];
					for (const msg of messages) {
						if (!Array.isArray(msg?.content)) continue;
						for (const block of msg.content) {
							if (
								block.type === "tool_use" &&
								block.name === "visualize:show_widget"
							) {
								const t = block.input?.title || "";
								if (t) widgetTitles.push(t);
							}
						}
					}

					if (widgetTitles.length > 0) {
						const selectedWidgets =
							await ClaudeProvider.WidgetCaptureDialog.show(widgetTitles);
						if (selectedWidgets === null) {
							// User cancelled export
							this.toast("Export cancelled.");
							return;
						}
						data.__exportWidgets = selectedWidgets;
					}
				}

				const { content, filename, stats } = provider.generateMarkdown(
					data,
					providerSettings,
				);

				const blob = new Blob([content], {
					type: "text/markdown;charset=utf-8",
				});
				const url = URL.createObjectURL(blob);
				const a = document.createElement("a");
				a.href = url;
				a.download = filename;
				a.click();
				URL.revokeObjectURL(url);

				// Download image files when explicitly enabled OR when relative inline paths are requested.
				// Widget SVGs are NOT downloaded - user must download manually via Claude's "Download file" button.
				let downloadedImageCount = 0;
				const shouldDownloadImageFiles = !!(
					providerSettings.IMAGE_DOWNLOAD_FILES ||
					providerSettings.IMAGE_MD_RELATIVE_PATH
				);
				if (shouldDownloadImageFiles) {
					const imageFiles = this.collectImageFiles(data, provider.name);
					if (imageFiles.length > 0) {
						// Small delay between downloads to avoid browser blocking
						for (let i = 0; i < imageFiles.length; i++) {
							await new Promise((r) => setTimeout(r, 150));
							const imgFile = imageFiles[i];
							const imgUrl = URL.createObjectURL(imgFile.blob);
							const imgA = document.createElement("a");
							imgA.href = imgUrl;
							imgA.download = imgFile.fileName;
							imgA.click();
							URL.revokeObjectURL(imgUrl);
						}
						downloadedImageCount = imageFiles.length;
						console.log(
							"[Chat Exporter] Downloaded",
							imageFiles.length,
							"image file(s)",
						);
					}
				}

				// Build detailed success message
				let successMsg = `Exported ${stats?.exported || 0} messages`;
				if (stats?.imagesEmbedded > 0) {
					successMsg += ` with ${stats.imagesEmbedded} inline image render${stats.imagesEmbedded !== 1 ? "s" : ""}`;
				}
				if (downloadedImageCount > 0) {
					successMsg += ` + ${downloadedImageCount} downloaded file${downloadedImageCount !== 1 ? "s" : ""}`;
				}
				if (stats?.modelsDetected !== undefined && stats?.assistantCount) {
					successMsg += ` (${stats.modelsDetected}/${stats.assistantCount} models detected)`;
				}
				this.toast(successMsg);
				State.error = null;
			} catch (err) {
				State.error = err.message;
				this.toast(`Failed: ${err.message}`);
				console.error("[Chat Exporter]", err);
			} finally {
				this.isExporting = false;
				this.update();
			}
		},

		/**
		 * Collect image blobs from fetched data for separate file download.
		 * @param {object} data - Raw API response data
		 * @param {string} providerName - Provider name
		 * @returns {Array<{fileName: string, blob: Blob}>}
		 */
		collectImageFiles(data, providerName) {
			const files = [];
			const seen = new Set();

			if (providerName === "Arena") {
				const messages = Array.isArray(data?.messages) ? data.messages : [];
				for (const msg of messages) {
					const attachments = Array.isArray(msg.experimental_attachments)
						? msg.experimental_attachments
						: [];
					attachments.forEach((att, idx) => {
						if (!att?.contentType?.startsWith("image/") || !att.__blob) return;
						const rawName = att.name
							? att.name.split("/").pop()
							: `image_${idx + 1}`;
						const fileName = Utils.sanitizeFilesystemName(rawName);
						if (seen.has(fileName)) return;
						seen.add(fileName);
						files.push({ fileName, blob: att.__blob });
					});
				}
				return files;
			}

			if (providerName === "ChatGPT") {
				const mapping = data?.mapping || {};
				const nodes = Object.values(mapping);
				for (const node of nodes) {
					const msg = node?.message;
					const content = msg?.content;
					if (
						!content ||
						content.content_type !== "multimodal_text" ||
						!Array.isArray(content.parts)
					)
						continue;
					for (const part of content.parts) {
						const img = part?.__chatgptImage;
						if (!img?.blob || !img?.fileName) continue;
						if (seen.has(img.fileName)) continue;
						seen.add(img.fileName);
						files.push({ fileName: img.fileName, blob: img.blob });
					}
				}
				return files;
			}

			if (providerName === "Claude") {
				// Widget SVGs are NOT downloaded by script - user must download manually via Claude's "Download file" button.
				// The browser saves to ~/Downloads; programmatic download would create duplicates in same location.
				// WidgetCache is only used for inline embedding (base64, data URI, raw SVG).
				return files;
			}

			return files;
		},

		toast(msg) {
			// Remove existing toasts
			for (const el of document.querySelectorAll(".chat-export-toast")) {
				el.remove();
			}

			const el = document.createElement("div");
			el.className = "chat-export-toast";
			el.textContent = msg;
			Object.assign(el.style, {
				position: "fixed",
				bottom: "80px",
				left: "50%",
				transform: "translateX(-50%)",
				background: "#333",
				color: "#fff",
				padding: "10px 20px",
				borderRadius: "8px",
				fontSize: "14px",
				fontFamily: "system-ui, sans-serif",
				zIndex: CONFIG.Z_INDEX,
				opacity: "0",
				transition: "opacity 0.3s",
				pointerEvents: "none",
			});
			document.body.appendChild(el);
			requestAnimationFrame(() => (el.style.opacity = "1"));
			setTimeout(() => {
				el.style.opacity = "0";
				setTimeout(() => el.remove(), 300);
			}, 2500);
		},
	};

	// ═══════════════════════════════════════════════════════════════════════════
	// ROUTER / OBSERVER
	// ═══════════════════════════════════════════════════════════════════════════
	let lastUrl = location.href;

	const checkRouter = () => {
		const provider = Providers.getCurrent();
		if (!provider) {
			if (UI.btn) UI.btn.style.display = "none";
			return;
		}

		const chatId = provider.extractChatId(location.href);
		if (UI.btn) {
			UI.btn.style.display = chatId ? "flex" : "none";
		}
		UI.update();
	};

	const init = () => {
		UI.init();
		checkRouter();

		// Poll for URL changes (handles SPA navigation)
		setInterval(() => {
			if (location.href !== lastUrl) {
				lastUrl = location.href;
				State.error = null;
				checkRouter();
			}
		}, 500);
	};

	// Start
	const bootstrap = () => {
		console.log("[Chat Exporter] Bootstrap starting...");
		console.log(
			"[Chat Exporter] PROVIDER_FLAGS defined:",
			Object.keys(PROVIDER_FLAGS),
		);
		console.log(
			"[Chat Exporter] FLAG_METADATA keys:",
			Object.keys(FLAG_METADATA).length,
		);
		// Install always-on widget SVG capture listener (Claude MCP)
		ClaudeProvider.WidgetCache.install();

		const provider = Providers.getCurrent();
		console.log("[Chat Exporter] Current provider:", provider?.name || "none");

		init();
		console.log("[Chat Exporter] Bootstrap complete");
	};

	if (document.body) {
		bootstrap();
	} else {
		window.addEventListener("DOMContentLoaded", bootstrap);
	}
})();
