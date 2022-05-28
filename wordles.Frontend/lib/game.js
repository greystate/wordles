"use strict";
function _typeof(e) {
  return (
    (_typeof =
      "function" == typeof Symbol && "symbol" == typeof Symbol.iterator
        ? function (e) {
            return typeof e;
          }
        : function (e) {
            return e &&
              "function" == typeof Symbol &&
              e.constructor === Symbol &&
              e !== Symbol.prototype
              ? "symbol"
              : typeof e;
          }),
    _typeof(e)
  );
}
function _defineProperty(e, t, n) {
  return (
    t in e
      ? Object.defineProperty(e, t, {
          value: n,
          enumerable: !0,
          configurable: !0,
          writable: !0,
        })
      : (e[t] = n),
    e
  );
}
!(function () {
  var e;
  function t() {
    dataLayer.push(arguments);
  }
  (window.dataLayer = window.dataLayer || []),
    t("js", new Date()),
    t("config", "G-BPTNZTTHF0");
  var n = "abcdefghijklmnopqrstuvwxyzæøå",
    r = 0,
    o = 1,
    a = 2,
    i =
      (_defineProperty((e = {}), r, "absent"),
      _defineProperty(e, o, "present"),
      _defineProperty(e, a, "match"),
      e),
    s = { PROGRESS: 0, WIN: 1, FAIL: 2 },
    c = 36e5,
    l = new Date(2022, 0, 9),
    u = l.getTime(),
    d = new Date(),
    f = d.getTime();
  d.getTimezoneOffset() < l.getTimezoneOffset() && (f += c);
  var v,
    m = function (e) {
      return e
        .split("")
        .map(function (e, t) {
          return n[(n.indexOf(e) + 2) % n.length];
        })
        .join("");
    },
    p = function (e) {
      return e
        .split("")
        .map(function (e, t) {
          return n[(n.length + (n.indexOf(e) - 2)) % n.length];
        })
        .join("");
    },
    h = function (e) {
      return e >= 0 && e <= 9 ? "0".concat(e) : e;
    },
    w = document.getElementById("game"),
    g = document.getElementById("board"),
    y = function (e) {
      var t = document.createElement("div");
      return (t.innerHTML = e), t.querySelector("svg");
    },
    S = function (e, t, n) {
      var r = document.createElement(e);
      if (t && "object" === _typeof(t)) for (var o in t) r[o] = t[o];
      return (
        n &&
          Array.isArray(n) &&
          n.forEach(function (e) {
            "string" == typeof e && (e = document.createTextNode(e)),
              r.appendChild(e);
          }),
        r
      );
    },
    L = "darkMode",
    x = "highContrast",
    b = (function () {
      try {
        return {
          darkMode: "true" === localStorage.getItem("darkMode"),
          highContrast: "true" === localStorage.getItem("highContrast"),
        };
      } catch (e) {
        return { darkMode: !1, highContrast: !1 };
      }
    })(),
    k = function (e, t) {
      var n = e === L ? "dm" : "hc";
      if (e === L) {
        var r = document.querySelector('meta[name="theme-color"]');
        r && r.setAttribute("content", !0 === t ? "#111112" : "#F8F8F8");
      }
      !0 === t
        ? (localStorage.setItem(e, JSON.stringify(!0)),
          document.body.classList.add(n),
          (b[e] = !0))
        : (localStorage.removeItem(e),
          document.body.classList.remove(n),
          (b[e] = !1));
    };
  b.darkMode && k(L, !0), b.highContrast && k(x, !0);
  var E,
    I,
    O,
    R,
    C =
      ((E = document.querySelector(".toasts")),
      (I = function (e) {
        e.addEventListener("transitionend", function () {
          e.remove();
        }),
          e.classList.add("out");
      }),
      function (e) {
        var t = S("div", { className: "toast" }, [e]);
        E.insertBefore(t, E.firstChild), setTimeout(I.bind(null, t), 1600);
      }),
    M = {
      guesses: { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0 },
      wins: 0,
      fails: 0,
      maxStreak: 0,
      currentStreak: 0,
    },
    N = Math.floor((f - u) / 864e5) + 1,
    P = {
      restored: !1,
      number: N,
      rows: [],
      word:
        ((O = words[N - 1]),
        p(
          codeMap.replacements.reduce(function (e, t, n) {
            return e.replace(t, codeMap.values[n]);
          }, O)
        )),
      status: s.PROGRESS,
      timestamp: new Date().getTime(),
    },
    T = {
      rows: [],
      keyboard: null,
      row: null,
      rowIndex: 0,
      columnIndex: 0,
      cursor: [-1, -1],
    },
    D = function () {
      var e;
      try {
        e = (e = localStorage.getItem("state")) ? JSON.parse(e) : null;
      } catch (e) {
        return;
      }
      if (e) {
        var t = (function (e) {
          var t = e.l;
          if (t && "object" === _typeof(t)) {
            for (
              var n = ["currentStreak", "fails", "wins", "maxStreak"], r = 0;
              r < n.length;
              r += 1
            )
              if ("number" != typeof t[n[r]]) return;
            return t;
          }
        })(e);
        t && ((P.restored = !0), Object.assign(M, t));
        var n = (function (e) {
          var t = parseInt(e.w, 10),
            n = P.number;
          if (!isNaN(t) && t === n) {
            var r = e.o;
            if (!1 !== Array.isArray(r)) {
              var o = e.r;
              if (!1 !== [s.PROGRESS, s.WIN, s.FAIL].includes(o)) {
                var a = e.d;
                if (("ftlv" === a && (a = "ftalv"), (a = a ? p(a) : null))) {
                  var i = e.e;
                  if (i && "number" == typeof i)
                    return {
                      number: t,
                      rows: r,
                      status: o,
                      word: a,
                      timestamp: i,
                    };
                }
              }
            }
          }
        })(e);
        e &&
          n &&
          n.number === N &&
          ((P.word = n.word),
          (P.timestamp = n.timestamp),
          (P.number = n.number),
          (P.rows = n.rows),
          (P.status = n.status));
      }
    },
    q = function (e, t) {
      var n = T.rows[t];
      return n ? n.tiles[e] : null;
    },
    A = function (e, t) {
      var n = q(T.cursor[0], T.cursor[1]);
      n && n.classList.remove("active");
      var r = q(e, t);
      r && r.classList.add("active"), (T.cursor = [e, t]);
    },
    j = function (e) {
      if (P.status === s.PROGRESS) {
        var t = T.row,
          n = t.tiles[T.columnIndex];
        n &&
          ((t.value[T.columnIndex] = e),
          (n.textContent = e),
          n.classList.add("filled"),
          (T.columnIndex += 1),
          A(Math.min(4, T.columnIndex), T.rowIndex));
      }
    },
    G = function () {
      if (!(T.columnIndex < 0 || P.status !== s.PROGRESS)) {
        var e = T.row,
          t = Math.max(0, T.columnIndex - 1);
        e.value[T.columnIndex] && (t = T.columnIndex);
        var n = e.tiles[t];
        n &&
          ((e.value[t] = null),
          (n.textContent = ""),
          n.classList.remove("filled"),
          (T.columnIndex = t),
          A(T.columnIndex, T.rowIndex));
      }
    },
    F = function () {
      if (P.status === s.PROGRESS) {
        var e = T.row.value,
          n = e.filter(function (e) {
            return !e;
          }).length;
        if (n > 0)
          return (
            C(
              "Du mangler at udfylde ".concat(n, " ") +
                (1 === n ? "bogstav" : "bogstaver")
            ),
            J(T.row.element)
          );
        var i = (function (e) {
          return codeMap.values.reduce(function (e, t, n) {
            return e.replace(t, codeMap.replacements[n]);
          }, m(e));
        })(e.join(""));
        if (!0 !== words.includes(i))
          return C("Ordet findes ikke i vores ordbog"), J(T.row.element);
        var c = e.join("") === P.word,
          l = 5 === T.rowIndex,
          u = T.rows[T.rowIndex + 1],
          d = [];
        c ? (P.status = s.WIN) : l && (P.status = s.FAIL);
        var f,
          v = P.status === s.WIN || P.status === s.FAIL,
          p = P.word.split(""),
          h = e.concat();
        if (
          (h.forEach(function (e, t) {
            return -1 === p.indexOf(e)
              ? ((d[t] = r), void (h[t] = null))
              : p[t] === e
              ? ((d[t] = a), (p[t] = null), void (h[t] = null))
              : void 0;
          }),
          h.forEach(function (e, t) {
            if (null !== e) {
              var n = p.indexOf(e);
              -1 !== n ? ((d[t] = o), (p[n] = null)) : (d[t] = r);
            }
          }),
          (P.rows[T.rowIndex] = [e, d]),
          K(T.row, d, function () {
            c
              ? (C("Godt gået!"), U(T.row.tiles))
              : l && C("Øv - prøv igen i morgen!"),
              v && setTimeout(Q.open, 1e3);
          }),
          v)
        ) {
          var w = P.status === s.WIN;
          t("event", "lvlend", { status: P.status, number: P.number }),
            w
              ? ((M.wins += 1),
                (M.currentStreak += 1),
                M.currentStreak > M.maxStreak &&
                  (M.maxStreak = M.currentStreak),
                (M.guesses[P.rows.length] += 1))
              : ((M.currentStreak = 0), (M.fails += 1)),
            A(-1, -1);
        }
        (f = {
          w: P.number,
          o: P.rows,
          r: P.status,
          d: m(P.word),
          l: M,
          e: P.timestamp,
        }),
          localStorage.setItem("state", JSON.stringify(f)),
          u &&
            !c &&
            ((T.rowIndex += 1),
            (T.row = u),
            (T.columnIndex = 0),
            A(T.columnIndex, T.rowIndex));
      }
    },
    _ = function () {
      if (v) {
        var e = g.clientHeight,
          t = Math.floor(0.8333333333333334 * e - 20);
        t !== R && (v.style.width = "".concat(t < 160 ? 160 : t, "px")),
          (R = t);
      }
    };
  window.addEventListener("resize", _),
    document.addEventListener("keydown", function (e) {
      if (P.status === s.PROGRESS) {
        var t = e.key,
          r = e.metaKey,
          o = e.code;
        if (!r) {
          if ("ArrowLeft" === t || "ArrowRight" === t) {
            var a = "ArrowRight" === t ? 1 : -1,
              i = Math.min(T.columnIndex, 4),
              c = Math.max(0, Math.min(i + a, 4));
            A(c, T.rowIndex), (T.columnIndex = c);
          }
          if ("Backspace" === o)
            return e.preventDefault(), e.stopPropagation(), G();
          if ("Enter" === o)
            return e.preventDefault(), e.stopPropagation(), F();
          if (t) {
            e.preventDefault(), e.stopPropagation();
            var l = t.toLowerCase();
            -1 !== n.indexOf(l) && j(l);
          }
        }
      }
    });
  var B,
    W,
    H,
    z = function () {
      for (var e = [], t = 0; t < 5; t += 1) {
        var n = S("div", { className: "tile" });
        e.push(n);
      }
      return e;
    },
    J = function (e) {
      e.addEventListener("animationend", function t() {
        e.classList.remove("shake"), e.removeEventListener("animationend", t);
      }),
        e.classList.add("shake");
    },
    K = function (e, t, n) {
      var r = e.tiles,
        o = e.value,
        a = T.keyboard;
      r.forEach(function (e, s) {
        o[s];
        var c = i[t[s]];
        e.classList.add("reveal-in"),
          (e.style.animationDelay = "".concat(80 * s, "ms")),
          e.addEventListener("animationend", function l() {
            var u = s === r.length - 1;
            e.classList.remove("reveal-in"),
              e.classList.remove("filled"),
              e.classList.add("reveal-out"),
              e.classList.add(c),
              (e.style.animationDelay = null),
              e.removeEventListener("animationend", l),
              u &&
                (t.forEach(function (e, t) {
                  var n = o[t];
                  if (!a.state[n] || e > a.state[n]) {
                    var r = i[e],
                      s = T.keyboard.byLetter[n];
                    a.state[n] >= 0 && s.classList.remove(i[a.state[n]]),
                      (a.state[n] = e),
                      (s.style.transitionDelay = "".concat(20 * t, "ms")),
                      s.classList.add(r);
                  }
                }),
                n && setTimeout(n, 80 * s));
          });
      });
    },
    U = function (e) {
      e.forEach(function (e, t) {
        e.classList.add("dance"),
          (e.style.animationDelay = "".concat(100 * t, "ms"));
      });
    },
    V = (function () {
      var e = document.querySelector(".settings-modal");
      if (e) {
        var t = e.querySelector('input[name="darkMode"]'),
          n = e.querySelector('input[name="highContrast"]');
        b.darkMode && (t.checked = !0), b.highContrast && (n.checked = !0);
        var r = function (e) {
          var t = e.target;
          (t && t.closest(".dialog")) || o();
        };
        e.addEventListener("change", function (e) {
          var t = e.target.closest("input[type=checkbox]");
          t &&
            ("darkMode" === t.name && k(L, t.checked),
            "highContrast" === t.name && k(x, t.checked));
        });
        var o = function () {
          e.removeEventListener("click", r),
            e.addEventListener("animationend", function t() {
              e.classList.remove("out"),
                e.removeEventListener("animationend", t);
            }),
            e.classList.remove("in"),
            e.classList.add("out");
        };
        return {
          open: function () {
            e.classList.add("in"), e.addEventListener("click", r);
          },
          close: o,
        };
      }
    })(),
    Y =
      ((B = document.querySelector(".help-modal")),
      (W = function (e) {
        var t = e.target;
        (t && t.closest(".dialog")) || H();
      }),
      {
        open: function () {
          B.classList.add("in"), B.addEventListener("click", W);
        },
        close: (H = function () {
          B.removeEventListener("click", W),
            B.addEventListener("animationend", function e() {
              B.classList.remove("out"),
                B.removeEventListener("animationend", e);
            }),
            B.classList.remove("in"),
            B.classList.add("out");
        }),
      }),
    Z = function (e) {
      var t = { text: e };
      if (
        navigator.canShare &&
        navigator.canShare(t) &&
        !(
          (navigator && navigator.platform ? navigator.platform : "").indexOf(
            "Win"
          ) >= 0
        )
      )
        return navigator.share(t);
      var n = !1;
      if (navigator.clipboard && navigator.clipboard.writeText)
        try {
          navigator.clipboard.writeText(e), (n = !0);
        } catch (e) {
          n = !1;
        }
      if (!n) {
        var r = S("textarea", {
          style: "opacity: 0; width: 0; height: 0; overflow: hidden;",
        });
        (r.textContent = e),
          document.body.appendChild(r),
          r.select(),
          document.execCommand("copy"),
          document.body.removeChild(r);
      }
      C("Resultatet er kopieret!");
    },
    Q = (function () {
      var e,
        t,
        n,
        a,
        i,
        c,
        l,
        u,
        d = document.querySelector(".stats-modal"),
        f = d.querySelector(".btn[data-action=share]"),
        v = d.querySelector(".dialog"),
        m =
          ((n = new Date()),
          (a = !1),
          (i = null),
          (c = null),
          (l = !1),
          (u = function n() {
            var r = t - new Date().getTime();
            if (r < 0) {
              if (!l) {
                var o = S("button", { className: "play-now" }, [
                  "Spil nu",
                  y(
                    '<svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>'
                  ),
                ]);
                o.addEventListener("click", function () {
                  window.location.reload();
                }),
                  (l = !0),
                  c.remove(),
                  i.appendChild(o);
              }
            } else {
              r >= 0 && a && (e = setTimeout(n, 1e3));
              var s = Math.floor(r / 36e5),
                u = Math.floor((r / 6e4) % 60),
                d = Math.floor((r / 1e3) % 60);
              c.textContent = ""
                .concat(h(s), ":")
                .concat(h(u), ":")
                .concat(h(d));
            }
          }),
          {
            start: function () {
              var r = v.querySelector(".footer");
              r &&
                ((t = new Date(
                  n.getFullYear(),
                  n.getMonth(),
                  n.getDate() + 1,
                  0,
                  0,
                  0,
                  0
                )),
                e && (clearTimeout(e), (e = null)),
                (a = !0),
                i ||
                  ((c = S("div", { className: "timer" })),
                  (i = S("div", { className: "countdown" }, [
                    "Næste wørdle",
                    c,
                  ])),
                  r.insertBefore(i, f)),
                u());
            },
            stop: function () {
              (a = !1), e && (clearTimeout(e), (e = null));
            },
          }),
        p = function (e) {
          var t = e.target;
          if (t) {
            var n = t.closest("[data-action]"),
              a = n ? n.getAttribute("data-action") : null;
            return "closeModal" === a
              ? w()
              : "share" === a
              ? Z(
                  (function () {
                    var e = P.number,
                      t = P.status === s.WIN ? P.rows.length : "x",
                      n = "Wørdle #".concat(e, " ").concat(t, "/6\n\n");
                    return (
                      P.rows.forEach(function (e) {
                        var t = e[1].map(function (e) {
                          return e === r ? "⬛" : e === o ? "🟦" : "🟩";
                        });
                        n += t.join("") + "\n";
                      }),
                      n
                    );
                  })()
                )
              : void (t.closest(".dialog") || w());
          }
        },
        w = function () {
          d.removeEventListener("click", p),
            d.classList.remove("in"),
            d.classList.add("out"),
            d.addEventListener("animationend", function e() {
              d.classList.remove("out"),
                d.removeEventListener("animationend", e);
            }),
            m.stop();
        };
      return {
        open: function () {
          var e = M.wins + M.fails,
            t = {
              played: e,
              win: 0 === e ? "0%" : Math.round((M.wins / e) * 100) + "%",
              currentStreak: M.currentStreak,
              maxStreak: M.maxStreak,
            },
            n = P.status !== s.PROGRESS,
            r = (P.status, s.PROGRESS, d.querySelector(".word-panel"));
          f.classList.toggle("hidden", !n),
            (r.querySelector("#word").textContent = P.word.toUpperCase()),
            r.classList.toggle("hidden", !n),
            P.status !== s.PROGRESS && m.start(),
            d.querySelectorAll(".stats div[data-type]").forEach(function (e) {
              var n = e.getAttribute("data-type");
              t.hasOwnProperty(n) &&
                (e.querySelector(".value").textContent = t[n]);
            }),
            d.addEventListener("click", p),
            d.classList.add("in"),
            d.classList.remove("out");
        },
        close: w,
      };
    })();
  document.addEventListener("click", function (e) {
    var t = e.target.closest("[data-action]");
    switch (t ? t.getAttribute("data-action") : null) {
      case "showHelp":
        return Y.open();
      case "showStats":
        return Q.open();
      case "showSettings":
        return V.open();
      case "closeHelp":
        return Y.close();
      case "closeStats":
        return Q.close();
      case "closeSettings":
        return V.close();
    }
  });
  !(function () {
    D(), (v = S("div", { className: "rows" }));
    for (var e = [], t = 0; t < 6; t += 1) {
      var n = z(),
        r = S("div", { className: "row" }, n);
      v.appendChild(r),
        T.rows.push({
          value: [null, null, null, null, null],
          index: t,
          element: r,
          tiles: n,
        });
    }
    var o = function (t) {
        var n = t.target.closest(".tile");
        if (n) {
          t.preventDefault();
          var r = n.closest(".row"),
            o = T.rows.find(function (e) {
              return e.element === r;
            });
          if (!o) return;
          var a = o.tiles.indexOf(n),
            i = o.value[a];
          P.status === s.PROGRESS &&
            o === T.row &&
            (A(a, T.rowIndex), (T.columnIndex = a)),
            i &&
              (function (t) {
                T.rows.forEach(function (n) {
                  n.value.join("") &&
                    n.value.forEach(function (r, o) {
                      if (r === t) {
                        var a = n.tiles[o];
                        a && (e.push(a), a.classList.add("highlight"));
                      }
                    });
                });
              })(i);
        }
      },
      a = function (t) {
        e.length &&
          (e.forEach(function (e) {
            return e.classList.remove("highlight");
          }),
          (e = []));
      };
    g.addEventListener("mousedown", o),
      g.addEventListener("touchstart", o),
      g.addEventListener("mouseup", a),
      g.addEventListener("touchend", a),
      g.appendChild(v),
      w.appendChild(
        (function () {
          var e = { keys: [], letters: [], byLetter: {}, state: {} },
            t = [
              "qwertyuiopå".split(""),
              "asdfghjklæø".split(""),
              "zxcvbnm\n\b".split(""),
            ].map(function (t) {
              var n = t.map(function (t) {
                var n;
                return (
                  (n =
                    "\b" === t
                      ? S(
                          "button",
                          { className: "backspace", ariaLabel: "Slet" },
                          [
                            y(
                              '<svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-delete" viewBox="0 0 24 24"><path d="M21 4H8l-7 8 7 8h13a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2zm-3 5-6 6m0-6 6 6"/></svg>'
                            ),
                          ]
                        )
                      : "\n" === t
                      ? S("button", { className: "return" }, [
                          S("span", null, ["Retur"]),
                        ])
                      : S("button", null, [t])),
                  (e.byLetter[t] = n),
                  e.letters.push(t),
                  e.keys.push(n),
                  n
                );
              });
              return S("div", { className: "keyboard-row" }, n);
            });
          T.keyboard = e;
          var n = S("div", { id: "keyboard" }, t);
          return (
            n.addEventListener("click", function (t) {
              t.preventDefault(), t.stopPropagation();
              var n = t.target.closest("button"),
                r = e.keys.indexOf(n),
                o = e.letters[r],
                a = o.charCodeAt(0);
              8 === a ? G() : 10 === a ? F() : j(o);
            }),
            n
          );
        })()
      ),
      P.rows.length
        ? (P.rows.forEach(function (e, t) {
            var n = T.rows[t],
              r = t === P.rows.length - 1;
            (n.value = e[0]),
              n.tiles.forEach(function (t, n) {
                t.textContent = e[0][n];
              }),
              K(n, e[1], function () {
                r && P.status === s.PROGRESS && A(0, P.rows.length);
              });
          }),
          P.status === s.PROGRESS
            ? ((T.rowIndex = P.rows.length), (T.row = T.rows[T.rowIndex]))
            : setTimeout(Q.open, 800))
        : (A(0, 0), (T.row = T.rows[0])),
      P.restored || setTimeout(Y.open, 200);
  })(),
    _();
})();
