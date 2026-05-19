/* =============================================================================
   Bandung Base Builders — Workshop Presentations
   Shared client-side helpers. Loaded by every session HTML and the home page.
   No build step. No frameworks. Vanilla browser APIs only.
   ============================================================================ */

(function () {
  "use strict";

  // ---------------------------------------------------------------------------
  // Public namespace
  // ---------------------------------------------------------------------------
  const BBB = {};
  window.BBB = BBB;

  // ---------------------------------------------------------------------------
  // 1. localStorage helpers
  // ---------------------------------------------------------------------------
  const NS = "bbb.v1.";

  BBB.storage = {
    get(key, fallback = null) {
      try {
        const raw = localStorage.getItem(NS + key);
        return raw == null ? fallback : JSON.parse(raw);
      } catch (_) { return fallback; }
    },
    set(key, value) {
      try { localStorage.setItem(NS + key, JSON.stringify(value)); } catch (_) { /* quota */ }
    },
    del(key) { try { localStorage.removeItem(NS + key); } catch (_) {} }
  };

  BBB.completion = {
    isDone(sessionN) { return !!BBB.storage.get(`done.meet-${sessionN}`); },
    markDone(sessionN, done = true) { BBB.storage.set(`done.meet-${sessionN}`, !!done); },
    all() {
      const out = {};
      for (let i = 1; i <= 8; i++) out[i] = BBB.completion.isDone(i);
      return out;
    }
  };

  // ---------------------------------------------------------------------------
  // 2. Persistent checklist
  // Any <label class="check"><input type="checkbox" data-checklist="meet-1-take-home" data-key="forge"></label>
  // ---------------------------------------------------------------------------
  BBB.initChecklists = function () {
    document.querySelectorAll("input[type=checkbox][data-checklist][data-key]").forEach((cb) => {
      const group = cb.dataset.checklist;
      const key = cb.dataset.key;
      const stateKey = `chk.${group}`;
      const state = BBB.storage.get(stateKey, {}) || {};
      cb.checked = !!state[key];
      cb.closest("label.check")?.classList.toggle("done", cb.checked);
      cb.addEventListener("change", () => {
        const s = BBB.storage.get(stateKey, {}) || {};
        s[key] = cb.checked;
        BBB.storage.set(stateKey, s);
        cb.closest("label.check")?.classList.toggle("done", cb.checked);
        // Notify any progress bars watching this group.
        document.querySelectorAll(`[data-checklist-progress="${group}"]`).forEach((p) => {
          updateProgress(p, group);
        });
      });
    });

    document.querySelectorAll("[data-checklist-progress]").forEach((p) => {
      updateProgress(p, p.dataset.checklistProgress);
    });
  };

  function updateProgress(el, group) {
    const all = document.querySelectorAll(`input[data-checklist="${group}"]`);
    const done = document.querySelectorAll(`input[data-checklist="${group}"]:checked`);
    const total = all.length || 1;
    const pct = Math.round((done.length / total) * 100);
    const bar = el.querySelector("span");
    if (bar) bar.style.width = pct + "%";
    const label = el.querySelector(".progress-label");
    if (label) label.textContent = `${done.length} / ${total}`;
  }

  // ---------------------------------------------------------------------------
  // 3. Scrollspy via IntersectionObserver
  // Any section with id="..." and a corresponding <a href="#..."> in .sidenav
  // ---------------------------------------------------------------------------
  BBB.initScrollspy = function () {
    const links = Array.from(document.querySelectorAll(".sidenav a[href^='#'], .mobile-nav a[href^='#']"));
    if (!links.length) return;

    const map = new Map();
    links.forEach((a) => {
      const id = a.getAttribute("href").slice(1);
      if (!id) return;
      const target = document.getElementById(id);
      if (target) map.set(id, a);
    });

    const setActive = (id) => {
      links.forEach((a) => a.classList.toggle("active", a.getAttribute("href") === "#" + id));
    };

    const obs = new IntersectionObserver(
      (entries) => {
        const visible = entries
          .filter((e) => e.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio);
        if (visible.length) setActive(visible[0].target.id);
      },
      { rootMargin: "-30% 0px -55% 0px", threshold: [0, 0.1, 0.25, 0.5, 1] }
    );

    map.forEach((_, id) => {
      const el = document.getElementById(id);
      if (el) obs.observe(el);
    });
  };

  // ---------------------------------------------------------------------------
  // 4. "Copy code" buttons on every <pre><code>
  // ---------------------------------------------------------------------------
  BBB.initCopyButtons = function () {
    document.querySelectorAll("pre[class*='language-']").forEach((pre) => {
      if (pre.closest(".code-wrap")) return;
      const wrap = document.createElement("div");
      wrap.className = "code-wrap";
      pre.parentNode.insertBefore(wrap, pre);
      wrap.appendChild(pre);
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "code-copy";
      btn.textContent = "Copy";
      wrap.appendChild(btn);
      btn.addEventListener("click", async () => {
        const code = pre.querySelector("code");
        const text = code ? code.textContent : pre.textContent;
        try {
          await navigator.clipboard.writeText(text);
          btn.textContent = "Copied!";
          btn.classList.add("copied");
          setTimeout(() => {
            btn.textContent = "Copy";
            btn.classList.remove("copied");
          }, 1500);
        } catch (_) {
          btn.textContent = "Copy failed";
          setTimeout(() => (btn.textContent = "Copy"), 1500);
        }
      });
    });
  };

  // ---------------------------------------------------------------------------
  // 5. Mobile nav
  // ---------------------------------------------------------------------------
  BBB.initMobileNav = function () {
    const toggle = document.querySelector(".nav-toggle");
    const nav = document.querySelector(".mobile-nav");
    if (!toggle || !nav) return;
    toggle.addEventListener("click", () => nav.classList.toggle("open"));
    nav.addEventListener("click", (e) => {
      if (e.target.tagName === "A") nav.classList.remove("open");
    });
  };

  // ---------------------------------------------------------------------------
  // 6. "Mark this session complete" button
  // <button data-mark-complete="1">Mark complete</button>
  // ---------------------------------------------------------------------------
  BBB.initMarkComplete = function () {
    document.querySelectorAll("[data-mark-complete]").forEach((btn) => {
      const n = parseInt(btn.dataset.markComplete, 10);
      const refresh = () => {
        const done = BBB.completion.isDone(n);
        btn.textContent = done ? "Marked complete ✓" : "Mark this session complete";
        btn.classList.toggle("btn-ghost", done);
        btn.classList.toggle("btn-primary", !done);
      };
      refresh();
      btn.addEventListener("click", () => {
        BBB.completion.markDone(n, !BBB.completion.isDone(n));
        refresh();
      });
    });
  };

  // ---------------------------------------------------------------------------
  // 7. Home page: stamp completion onto session cards
  // ---------------------------------------------------------------------------
  BBB.initHomeCompletion = function () {
    document.querySelectorAll("[data-session-card]").forEach((card) => {
      const n = parseInt(card.dataset.sessionCard, 10);
      if (BBB.completion.isDone(n)) card.classList.add("done");
    });
    const all = BBB.completion.all();
    const total = Object.values(all).filter(Boolean).length;
    const bar = document.querySelector("[data-cohort-progress] span");
    const lbl = document.querySelector("[data-cohort-progress-label]");
    if (bar) bar.style.width = Math.round((total / 8) * 100) + "%";
    if (lbl) lbl.textContent = `${total} / 8`;
  };

  // ---------------------------------------------------------------------------
  // 8. Live block-number fetcher (used by Meet 1)
  // ---------------------------------------------------------------------------
  BBB.fetchBlockNumber = async function (rpcUrl = "https://sepolia.base.org") {
    const res = await fetch(rpcUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ jsonrpc: "2.0", id: 1, method: "eth_blockNumber", params: [] }),
    });
    if (!res.ok) throw new Error("RPC HTTP " + res.status);
    const json = await res.json();
    if (json.error) throw new Error(json.error.message);
    return parseInt(json.result, 16);
  };

  // Generic eth_call helper for Meet 2's live demo.
  BBB.ethCall = async function (rpcUrl, to, data) {
    const res = await fetch(rpcUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        jsonrpc: "2.0", id: 1, method: "eth_call",
        params: [{ to, data }, "latest"],
      }),
    });
    if (!res.ok) throw new Error("RPC HTTP " + res.status);
    const json = await res.json();
    if (json.error) throw new Error(json.error.message);
    return json.result;
  };

  // ---------------------------------------------------------------------------
  // 9. Tabs (generic: data-tabs="name", data-tab="key" on triggers/panels)
  // ---------------------------------------------------------------------------
  BBB.initTabs = function () {
    document.querySelectorAll("[data-tabs]").forEach((root) => {
      const name = root.dataset.tabs;
      const tabs = root.querySelectorAll(`[data-tab][data-tabs-group="${name}"]`);
      const panels = document.querySelectorAll(`[data-tabpanel][data-tabs-group="${name}"]`);
      const activate = (key) => {
        tabs.forEach((t) => t.classList.toggle("active", t.dataset.tab === key));
        panels.forEach((p) => (p.hidden = p.dataset.tabpanel !== key));
      };
      tabs.forEach((t) => t.addEventListener("click", () => activate(t.dataset.tab)));
      const first = tabs[0];
      if (first) activate(first.dataset.tab);
    });
  };

  // ---------------------------------------------------------------------------
  // 10. Reveal toggles (used in Meet 4 for "show solution")
  // ---------------------------------------------------------------------------
  BBB.initReveals = function () {
    document.querySelectorAll("[data-reveal-trigger]").forEach((btn) => {
      const id = btn.dataset.revealTrigger;
      const target = document.getElementById(id);
      if (!target) return;
      target.hidden = true;
      btn.addEventListener("click", () => {
        target.hidden = !target.hidden;
        btn.textContent = target.hidden ? btn.dataset.showLabel || "Reveal solution" : btn.dataset.hideLabel || "Hide solution";
      });
      btn.textContent = btn.dataset.showLabel || "Reveal solution";
    });
  };

  // ---------------------------------------------------------------------------
  // 11. Flip cards (Meet 3)
  // ---------------------------------------------------------------------------
  BBB.initFlipCards = function () {
    document.querySelectorAll(".flip-card").forEach((card) => {
      card.addEventListener("click", () => card.classList.toggle("flipped"));
    });
  };

  // ---------------------------------------------------------------------------
  // 12. Auto-init on DOMContentLoaded
  // ---------------------------------------------------------------------------
  document.addEventListener("DOMContentLoaded", () => {
    try { BBB.initScrollspy(); } catch (e) { console.error(e); }
    try { BBB.initChecklists(); } catch (e) { console.error(e); }
    try { BBB.initCopyButtons(); } catch (e) { console.error(e); }
    try { BBB.initMobileNav(); } catch (e) { console.error(e); }
    try { BBB.initMarkComplete(); } catch (e) { console.error(e); }
    try { BBB.initHomeCompletion(); } catch (e) { console.error(e); }
    try { BBB.initTabs(); } catch (e) { console.error(e); }
    try { BBB.initReveals(); } catch (e) { console.error(e); }
    try { BBB.initFlipCards(); } catch (e) { console.error(e); }
  });

  // ---------------------------------------------------------------------------
  // 13. Utility: format number with thousands separator
  // ---------------------------------------------------------------------------
  BBB.fmt = function (n, opts = {}) {
    const { decimals = 0, currency = false } = opts;
    if (Number.isNaN(n) || n === Infinity || n === -Infinity) return "—";
    const s = Number(n).toLocaleString("en-US", {
      minimumFractionDigits: decimals,
      maximumFractionDigits: decimals,
    });
    return currency ? "$" + s : s;
  };
})();
