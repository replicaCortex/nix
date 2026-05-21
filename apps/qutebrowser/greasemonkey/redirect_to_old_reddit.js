// ==UserScript==
// @name         Reddit Old Redirect 🔙
// @namespace    https://www.reddit.com
// @version      1.9
// @description  redirect to old reddit
// @author       Agreasyforkuser
// @match        https://*.reddit.com/*
// @exclude      https://*.reddit.com/poll/*
// @exclude      https://*.reddit.com/gallery/*
// @exclude      https://chat.reddit.com/*
// @exclude      https://www.reddit.com/appeal*
// @exclude      https://www.reddit.com/notifications*
// @exclude      https://embed.reddit.com/*
// @exclude      https://www.reddit.com/mail/*
// @exclude      https://sh.reddit.com/report-flow*
// @icon         https://www.redditstatic.com/desktop2x/img/favicon/android-icon-192x192.png
// @license      MIT
// @run-at       document-start
// @downloadURL https://update.greasyfork.org/scripts/471477/Reddit%20Old%20Redirect%20%F0%9F%94%99.user.js
// @updateURL https://update.greasyfork.org/scripts/471477/Reddit%20Old%20Redirect%20%F0%9F%94%99.meta.js
// ==/UserScript==

(function() {
    'use strict';

    // do nothing if we are already on old.reddit.com
    if (window.location.hostname === 'old.reddit.com') return;

    // feature to display raw media embeddings, avoid new reddit media viewer
    // redirect "https://preview.redd.it/image.jpeg" links to blank page with raw image
    const href = window.location.href;
    const params = new URLSearchParams(window.location.search);
    const imgParam = params.get('url');
    if (imgParam && /\.(?:png|jpe?g|gif|webp|bmp)(?:\?.*)?$/i.test(imgParam)) {
        document.open();
        document.write(`
       <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <title>Reddit Media</title>
            <style>
                html, body {
                    margin: 0;
                    padding: 0;
                    width: 100%;
                    height: 100%;
                    background: black;
                    overflow: hidden; /* Prevent scrolling */
                }
                body {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                }
                img {
                    max-width: 100vw;
                    max-height: 100vh;
                    width: auto;
                    height: auto;
                    object-fit: contain;
                }
            </style>
        </head>
        <body>
            <img src="${imgParam}" alt="image">
        </body>
        </html>`);
        document.close();
        return;
    }

    // general Redirect to old.reddit.com
    if ( window.location.host != "old.reddit.com" ) {
        var oldReddit = window.location.protocol + "//" + "old.reddit.com" + window.location.pathname + window.location.search + window.location.hash;
        window.location.replace (oldReddit);
    }
})();