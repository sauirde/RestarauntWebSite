/**
 * reservation.js — многошаговый мастер бронирования столика.
 *
 * Самодостаточный модуль: сам рендерит разметку и стили внутри
 * контейнера, ходит в API проекта, хранит выбор в reservationState.
 *
 * Использование:
 *   <div id="reservation-wizard"></div>
 *   <script src="/static/js/reservation.js"></script>
 * либо вручную: ReservationWizard.init(document.querySelector('#el'))
 *
 * Шаги: город → данные → зал → дата/гости → время → подтверждение → итог.
 */
(function (global) {
  "use strict";

  var API = "/api";

  // Глобальное состояние выбора пользователя.
  var reservationState = {
    city: null,
    branchId: null,
    branchLabel: null,
    firstName: "",
    lastName: "",
    phone: "",
    email: "",
    hallId: null,
    hallLabel: null,
    hallCapacity: null,
    date: "",
    guests: 2,
    time: ""
  };

  // Кол-во интерактивных шагов для прогресс-бара (без экрана результата).
  var TOTAL_STEPS = 6;

  // ---- утилиты ------------------------------------------------------------
  function el(tag, cls, html) {
    var n = document.createElement(tag);
    if (cls) n.className = cls;
    if (html != null) n.innerHTML = html;
    return n;
  }
  function esc(s) {
    var d = document.createElement("div");
    d.textContent = s == null ? "" : String(s);
    return d.innerHTML;
  }
  function getCookie(name) {
    var m = document.cookie.match("(^|;)\\s*" + name + "\\s*=\\s*([^;]+)");
    return m ? m.pop() : "";
  }
  function tenge(p) {
    return new Intl.NumberFormat("ru-RU").format(Math.round(parseFloat(p))) + " ₸";
  }
  function todayISO() {
    var d = new Date();
    d.setMinutes(d.getMinutes() - d.getTimezoneOffset());
    return d.toISOString().slice(0, 10);
  }
  function tomorrowISO() {
    var d = new Date();
    d.setDate(d.getDate() + 1);
    d.setMinutes(d.getMinutes() - d.getTimezoneOffset());
    return d.toISOString().slice(0, 10);
  }
  function normalizePhone(v) {
    var digits = (v || "").replace(/\D/g, "");
    if (digits.length === 11 && (digits[0] === "8" || digits[0] === "7")) {
      digits = "7" + digits.slice(1);
    }
    return digits ? "+" + digits : "";
  }

  // ---- стили (инжектятся один раз) ---------------------------------------
  var CSS =
    "" +
    ".rsv{--g:#c9a25a;--gb:#e7cf9b;--bg:#15110b;--sf:#1c1710;--ln:#3a2f1d;--tx:#ece4d4;--mt:#9d917a;" +
    "font-family:'Cormorant Garamond',Georgia,serif;color:var(--tx);background:var(--bg);" +
    "border:1px solid var(--ln);max-width:760px;margin:0 auto;overflow:hidden}" +
    ".rsv *{box-sizing:border-box}" +
    ".rsv-bar{display:flex;gap:6px;padding:18px 26px;background:#120f0a;border-bottom:1px solid var(--ln)}" +
    ".rsv-bar i{flex:1;height:3px;background:var(--ln);transition:.4s}" +
    ".rsv-bar i.on{background:var(--g)}" +
    ".rsv-vp{position:relative;min-height:430px}" +
    ".rsv-panel{padding:34px 36px;transition:transform .32s ease,opacity .32s ease}" +
    ".rsv-panel.out-l{transform:translateX(-40px);opacity:0}" +
    ".rsv-panel.out-r{transform:translateX(40px);opacity:0}" +
    ".rsv-step{font:600 13px/1 'Playfair Display',serif;letter-spacing:.28em;text-transform:uppercase;color:var(--g);margin-bottom:8px}" +
    ".rsv-h{font:600 28px/1.2 'Playfair Display',Georgia,serif;margin-bottom:24px}" +
    ".rsv-grid{display:grid;gap:14px}" +
    ".rsv-grid.c2{grid-template-columns:1fr 1fr}" +
    ".rsv-grid.c3{grid-template-columns:repeat(3,1fr)}" +
    "@media(max-width:560px){.rsv-grid.c2,.rsv-grid.c3{grid-template-columns:1fr}}" +
    ".rsv-opt{background:var(--sf);border:1px solid var(--ln);color:var(--tx);" +
    "font-family:inherit;font-size:18px;padding:18px;cursor:pointer;text-align:left;transition:.25s}" +
    ".rsv-opt:hover{border-color:var(--g)}" +
    ".rsv-opt.sel{border-color:var(--g);background:rgba(201,162,90,.2)}" +
    ".rsv-opt small{display:block;color:var(--mt);font-size:14px;margin-top:6px}" +
    ".rsv-fld{display:flex;flex-direction:column;gap:7px;margin-bottom:16px}" +
    ".rsv-fld label{font-size:13px;letter-spacing:.16em;text-transform:uppercase;color:var(--mt)}" +
    ".rsv-fld input{background:var(--sf);border:1px solid var(--ln);color:var(--tx);" +
    "font-family:inherit;font-size:18px;padding:13px 14px}" +
    ".rsv-fld input:focus{outline:none;border-color:var(--g)}" +
    ".rsv-fld.bad input{border-color:#d4775a}" +
    ".rsv-err{color:#e08a6f;font-size:14px;min-height:18px;margin-top:-8px;margin-bottom:10px}" +
    ".rsv-times{display:grid;grid-template-columns:repeat(5,1fr);gap:10px}" +
    "@media(max-width:560px){.rsv-times{grid-template-columns:repeat(3,1fr)}}" +
    ".rsv-t{background:var(--sf);border:1px solid var(--ln);color:var(--tx);font-family:inherit;" +
    "font-size:16px;padding:12px 0;cursor:pointer;transition:.2s}" +
    ".rsv-t:hover{border-color:var(--g)}" +
    ".rsv-t.sel{background:rgba(201,162,90,.2);color:var(--g);border-color:var(--g)}" +
    ".rsv-t.busy{color:#5c5340;background:#171309;cursor:not-allowed;border-color:#241d10}" +
    ".rsv-sum{list-style:none;padding:0;margin:0 0 24px}" +
    ".rsv-sum li{display:flex;justify-content:space-between;gap:14px;padding:12px 0;border-bottom:1px solid var(--ln)}" +
    ".rsv-sum span{color:var(--mt)}.rsv-sum b{font-weight:600;text-align:right}" +
    ".rsv-nav{display:flex;justify-content:space-between;align-items:center;gap:12px;" +
    "padding:20px 36px;border-top:1px solid var(--ln);background:#120f0a}" +
    ".rsv-btn{font:600 14px/1 'Playfair Display',serif;letter-spacing:.14em;text-transform:uppercase;" +
    "padding:14px 28px;border:1px solid var(--g);color:var(--gb);background:transparent;cursor:pointer;transition:.3s}" +
    ".rsv-btn:hover{background:var(--g);color:#1a1407}" +
    ".rsv-btn.solid{background:var(--g);color:#1a1407}" +
    ".rsv-btn[disabled]{opacity:.4;cursor:not-allowed}" +
    ".rsv-btn.ghost{border-color:var(--ln);color:var(--mt)}" +
    ".rsv-btn.ghost:hover{border-color:var(--g);color:var(--gb);background:transparent}" +
    ".rsv-note{color:var(--mt);font-size:15px;margin-top:10px}" +
    ".rsv-center{text-align:center;padding:46px 36px}" +
    ".rsv-center h2{font:600 30px/1.2 'Playfair Display',serif;margin:14px 0}" +
    ".rsv-id{font:600 22px/1 'Playfair Display',serif;color:var(--gb);letter-spacing:.06em;" +
    "border:1px solid var(--g);display:inline-block;padding:14px 26px;margin:18px 0}" +
    ".rsv-spin{width:34px;height:34px;border:3px solid var(--ln);border-top-color:var(--g);" +
    "border-radius:50%;animation:rsv-rot 1s linear infinite;margin:60px auto}" +
    "@keyframes rsv-rot{to{transform:rotate(360deg)}}" +
    ".rsv-ico{font-size:46px;line-height:1}";

  function injectCSS() {
    if (document.getElementById("rsv-css")) return;
    var s = el("style");
    s.id = "rsv-css";
    s.textContent = CSS;
    document.head.appendChild(s);
  }

  // ---- ядро мастера -------------------------------------------------------
  function Wizard(mount) {
    this.mount = mount;
    this.step = 0;
    this.branches = [];
    this.build();
    this.renderStep(0, 0);
  }

  Wizard.prototype.build = function () {
    this.mount.classList.add("rsv");
    this.bar = el("div", "rsv-bar");
    for (var i = 0; i < TOTAL_STEPS; i++) this.bar.appendChild(el("i"));
    this.vp = el("div", "rsv-vp");
    this.mount.appendChild(this.bar);
    this.mount.appendChild(this.vp);
  };

  Wizard.prototype.progress = function (n) {
    var dots = this.bar.children;
    for (var i = 0; i < dots.length; i++) dots[i].classList.toggle("on", i < n);
  };

  // direction: 1 — вперёд, -1 — назад, 0 — без анимации
  Wizard.prototype.renderStep = function (idx, direction) {
    var self = this;
    this.step = idx;
    var panel = el("div", "rsv-panel");
    STEPS[idx].render(this, panel);

    var old = this.current;
    this.current = panel;

    if (!old || direction === 0) {
      this.vp.innerHTML = "";
      this.vp.appendChild(panel);
      return;
    }
    // slide-анимация: старый уезжает, новый въезжает
    panel.classList.add(direction > 0 ? "out-r" : "out-l");
    old.classList.add(direction > 0 ? "out-l" : "out-r");
    this.vp.appendChild(panel);
    requestAnimationFrame(function () {
      requestAnimationFrame(function () {
        panel.classList.remove("out-r", "out-l");
      });
    });
    setTimeout(function () {
      if (old.parentNode) old.parentNode.removeChild(old);
    }, 340);
  };

  Wizard.prototype.go = function (idx) {
    this.renderStep(idx, idx > this.step ? 1 : -1);
  };

  Wizard.prototype.loading = function (panel) {
    panel.innerHTML = '<div class="rsv-spin"></div>';
  };

  Wizard.prototype.fail = function (panel, msg, retry) {
    panel.innerHTML = "";
    panel.appendChild(el("div", "rsv-step", "Ошибка"));
    panel.appendChild(el("p", "rsv-note", esc(msg)));
    var b = el("button", "rsv-btn", "Повторить");
    b.onclick = retry;
    panel.appendChild(el("div", null, "").appendChild(b).parentNode);
  };

  // навигация снизу (Назад / действие)
  function navBar(w, opts) {
    var nav = el("div", "rsv-nav");
    var back = el("button", "rsv-btn ghost", "← Назад");
    if (opts.back === false) back.style.visibility = "hidden";
    back.onclick = function () { w.go(w.step - 1); };
    nav.appendChild(back);

    if (opts.next) {
      var nx = el("button", "rsv-btn solid", opts.nextLabel || "Далее");
      nx.onclick = opts.next;
      if (opts.nextDisabled) nx.disabled = true;
      nav.appendChild(nx);
      w._next = nx;
    } else {
      nav.appendChild(el("span"));
    }
    return nav;
  }

  // ---- ШАГИ ---------------------------------------------------------------
  var STEPS = [

    // 0. Город (и филиал, если их несколько)
    {
      render: function (w, p) {
        w.progress(1);
        w.loading(p);
        fetch(API + "/branches/")
          .then(function (r) { if (!r.ok) throw 0; return r.json(); })
          .then(function (d) {
            w.branches = d.results || d;
            p.innerHTML = "";
            p.appendChild(el("div", "rsv-step", "Шаг 1 из 6"));
            p.appendChild(el("h2", "rsv-h", "Выберите город"));
            var cities = [];
            w.branches.forEach(function (b) {
              if (cities.indexOf(b.city_name) < 0) cities.push(b.city_name);
            });
            var grid = el("div", "rsv-grid c2");
            cities.forEach(function (c) {
              var btn = el("button", "rsv-opt", esc(c));
              if (reservationState.city === c) btn.classList.add("sel");
              btn.onclick = function () { pickCity(w, p, c, grid, btn); };
              grid.appendChild(btn);
            });
            p.appendChild(grid);
            p.appendChild(el("div", null, "")); // место под выбор филиала
            if (reservationState.city) pickCity(w, p, reservationState.city, grid, null, true);
          })
          .catch(function () {
            w.fail(p, "Не удалось загрузить филиалы. Проверьте, что сервер запущен.",
              function () { w.renderStep(0, 0); });
          });
      }
    },

    // 1. Данные гостя
    {
      render: function (w, p) {
        w.progress(2);
        p.appendChild(el("div", "rsv-step", "Шаг 2 из 6"));
        p.appendChild(el("h2", "rsv-h", "Ваши данные"));

        function field(id, label, val, type) {
          var f = el("div", "rsv-fld");
          f.appendChild(el("label", null, label)).htmlFor = id;
          var inp = el("input");
          inp.id = id; inp.value = val || ""; if (type) inp.type = type;
          f.appendChild(inp);
          p.appendChild(f);
          return inp;
        }
        var fn = field("rsv-fn", "Имя", reservationState.firstName);
        var ln = field("rsv-ln", "Фамилия", reservationState.lastName);
        var ph = field("rsv-ph", "Телефон", reservationState.phone || "+7");
        ph.placeholder = "+7XXXXXXXXXX";
        var em = field("rsv-em", "E-mail (необязательно)", reservationState.email, "email");
        var err = el("div", "rsv-err");
        p.appendChild(err);

        p.appendChild(navBar(w, {
          next: function () {
            err.textContent = "";
            var phone = normalizePhone(ph.value);
            if (!fn.value.trim() || !ln.value.trim()) {
              err.textContent = "Укажите имя и фамилию."; return;
            }
            if (!/^\+7\d{10}$/.test(phone)) {
              err.textContent = "Телефон в формате +7XXXXXXXXXX.";
              ph.parentNode.classList.add("bad"); return;
            }
            if (em.value.trim() && !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(em.value.trim())) {
              err.textContent = "Некорректный e-mail."; return;
            }
            reservationState.firstName = fn.value.trim();
            reservationState.lastName = ln.value.trim();
            reservationState.phone = phone;
            reservationState.email = em.value.trim();
            w.go(2);
          }
        }));
      }
    },

    // 2. Зал
    {
      render: function (w, p) {
        w.progress(3);
        w.loading(p);
        fetch(API + "/branches/" + reservationState.branchId + "/halls/")
          .then(function (r) { if (!r.ok) throw 0; return r.json(); })
          .then(function (halls) {
            p.innerHTML = "";
            p.appendChild(el("div", "rsv-step", "Шаг 3 из 6"));
            p.appendChild(el("h2", "rsv-h", "Выберите зал"));
            if (!halls.length) {
              p.appendChild(el("p", "rsv-note", "В этом филиале пока нет залов."));
            }
            var grid = el("div", "rsv-grid c2");
            halls.forEach(function (h) {
              var b = el("button", "rsv-opt",
                esc(h.name) + "<small>Вместимость: до " + esc(h.capacity) +
                " гостей" + (h.description ? " · " + esc(h.description) : "") + "</small>");
              if (reservationState.hallId === h.id) b.classList.add("sel");
              b.onclick = function () {
                reservationState.hallId = h.id;
                reservationState.hallLabel = h.name;
                reservationState.hallCapacity = h.capacity;
                if (reservationState.guests > h.capacity) reservationState.guests = h.capacity;
                w.go(3);
              };
              grid.appendChild(b);
            });
            p.appendChild(grid);
            p.appendChild(navBar(w, {}));
          })
          .catch(function () {
            w.fail(p, "Не удалось загрузить залы.", function () { w.renderStep(2, 0); });
          });
      }
    },

    // 3. Дата и гости
    {
      render: function (w, p) {
        w.progress(4);
        p.appendChild(el("div", "rsv-step", "Шаг 4 из 6"));
        p.appendChild(el("h2", "rsv-h", "Дата и гости"));

        var fd = el("div", "rsv-fld");
        fd.appendChild(el("label", null, "Дата (только будущие дни)"));
        var date = el("input"); date.type = "date";
        date.min = todayISO();
        date.value = reservationState.date || tomorrowISO();
        fd.appendChild(date); p.appendChild(fd);

        var fg = el("div", "rsv-fld");
        var cap = reservationState.hallCapacity || 50;
        fg.appendChild(el("label", null, "Количество гостей (макс. " + cap + ")"));
        var guests = el("input"); guests.type = "number";
        guests.min = 1; guests.max = cap; guests.value = reservationState.guests || 2;
        fg.appendChild(guests); p.appendChild(fg);

        var err = el("div", "rsv-err");
        p.appendChild(err);

        p.appendChild(navBar(w, {
          next: function () {
            err.textContent = "";
            var g = parseInt(guests.value, 10);
            if (!date.value || date.value < todayISO()) {
              err.textContent = "Выберите будущую дату."; return;
            }
            if (!g || g < 1 || g > cap) {
              err.textContent = "Гостей: от 1 до " + cap + "."; return;
            }
            reservationState.date = date.value;
            reservationState.guests = g;
            w.go(4);
          }
        }));
      }
    },

    // 4. Время (сетка; занятые — серые)
    {
      render: function (w, p) {
        w.progress(5);
        w.loading(p);
        fetch(API + "/branches/" + reservationState.branchId +
              "/timeslots/?date=" + reservationState.date)
          .then(function (r) { return r.json().then(function (b) { return { ok: r.ok, b: b }; }); })
          .then(function (res) {
            p.innerHTML = "";
            p.appendChild(el("div", "rsv-step", "Шаг 5 из 6"));
            p.appendChild(el("h2", "rsv-h", "Выберите время"));
            if (!res.ok) {
              p.appendChild(el("p", "rsv-note", (res.b && res.b.date) || "Дата недоступна."));
              p.appendChild(navBar(w, {}));
              return;
            }
            var d = res.b;
            var avail = d.available || [];
            // реконструируем полную сетку из метаданных, чтобы занятые были серыми
            var all = buildGrid(d);
            var note = el("p", "rsv-note",
              "Часы работы " + esc(d.working_hours) + ". Бронь на " +
              esc(d.booking_duration_hours) + " ч. Серые слоты — недоступны.");
            p.appendChild(note);
            var grid = el("div", "rsv-times");
            (all.length ? all : avail).forEach(function (t) {
              var free = avail.indexOf(t) >= 0;
              var b = el("button", "rsv-t" + (free ? "" : " busy"), t);
              if (reservationState.time === t && free) b.classList.add("sel");
              if (free) {
                b.onclick = function () {
                  reservationState.time = t;
                  w.go(5);
                };
              } else {
                b.disabled = true;
              }
              grid.appendChild(b);
            });
            if (!avail.length) {
              p.appendChild(el("p", "rsv-note", "На эту дату свободных слотов нет — выберите другую."));
            }
            p.appendChild(grid);
            p.appendChild(navBar(w, {}));
          })
          .catch(function () {
            w.fail(p, "Не удалось загрузить слоты.", function () { w.renderStep(4, 0); });
          });
      }
    },

    // 5. Подтверждение + POST
    {
      render: function (w, p) {
        w.progress(6);
        p.appendChild(el("div", "rsv-step", "Шаг 6 из 6"));
        p.appendChild(el("h2", "rsv-h", "Проверьте бронь"));
        var s = reservationState;
        var rows = [
          ["Город", s.city],
          ["Филиал", s.branchLabel],
          ["Гость", s.firstName + " " + s.lastName],
          ["Телефон", s.phone],
          ["E-mail", s.email || "—"],
          ["Зал", s.hallLabel],
          ["Дата", s.date],
          ["Гостей", s.guests],
          ["Время", s.time]
        ];
        var ul = el("ul", "rsv-sum");
        rows.forEach(function (r) {
          ul.appendChild(el("li", null,
            "<span>" + esc(r[0]) + "</span><b>" + esc(r[1]) + "</b>"));
        });
        p.appendChild(ul);
        var err = el("div", "rsv-err");
        p.appendChild(err);

        p.appendChild(navBar(w, {
          nextLabel: "Подтвердить бронь",
          next: function () {
            w._next.disabled = true;
            w._next.textContent = "Отправляем…";
            err.textContent = "";
            var payload = {
              branch: s.branchId, hall: s.hallId,
              first_name: s.firstName, last_name: s.lastName,
              phone: s.phone, email: s.email,
              date: s.date, time: s.time, guests_count: s.guests
            };
            fetch(API + "/reservations/", {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                "X-CSRFToken": getCookie("csrftoken")
              },
              credentials: "same-origin",
              body: JSON.stringify(payload)
            })
              .then(function (r) {
                return r.json().then(function (b) { return { ok: r.ok, b: b }; });
              })
              .then(function (res) {
                if (res.ok) {
                  w.result = { ok: true, data: res.b };
                  w.renderStep(6, 1);
                } else {
                  var k = Object.keys(res.b)[0];
                  var m = res.b[k];
                  err.textContent = (Array.isArray(m) ? m[0] : m) || "Проверьте данные.";
                  w._next.disabled = false;
                  w._next.textContent = "Подтвердить бронь";
                }
              })
              .catch(function () {
                w.result = { ok: false };
                w.renderStep(6, 1);
              });
          }
        }));
      }
    },

    // 6. Результат
    {
      render: function (w, p) {
        w.progress(TOTAL_STEPS);
        var r = w.result || { ok: false };
        p.className = "rsv-panel rsv-center";
        if (r.ok) {
          p.appendChild(el("div", "rsv-ico", "✓"));
          p.appendChild(el("h2", null, "Бронь принята"));
          p.appendChild(el("div", "rsv-id", "Бронь №" + esc(r.data.id)));
          p.appendChild(el("p", "rsv-note",
            "Статус: ожидает подтверждения. <b>Ждите SMS</b> — менеджер " +
            "свяжется с вами для подтверждения брони."));
          var done = el("button", "rsv-btn solid", "Готово");
          done.style.marginTop = "22px";
          done.onclick = function () { resetState(); w.renderStep(0, 0); };
          p.appendChild(done);
        } else {
          p.appendChild(el("div", "rsv-ico", "✕"));
          p.appendChild(el("h2", null, "Не удалось отправить"));
          p.appendChild(el("p", "rsv-note",
            "Произошла ошибка сети. Ваши данные сохранены — попробуйте ещё раз."));
          var back = el("button", "rsv-btn", "Вернуться к подтверждению");
          back.style.marginTop = "22px";
          back.onclick = function () { w.renderStep(5, -1); };
          p.appendChild(back);
        }
      }
    }
  ];

  // выбор города → подстановка кнопок филиалов (если их > 1)
  function pickCity(w, p, city, grid, btn, silent) {
    reservationState.city = city;
    var kids = grid.children;
    for (var i = 0; i < kids.length; i++) {
      kids[i].classList.toggle("sel", kids[i].textContent === city);
    }
    var holder = grid.nextSibling;
    holder.innerHTML = "";
    var list = w.branches.filter(function (b) { return b.city_name === city; });

    function choose(b) {
      reservationState.branchId = b.id;
      reservationState.branchLabel = b.address;
      w.go(1);
    }
    if (list.length === 1) {
      reservationState.branchId = list[0].id;
      reservationState.branchLabel = list[0].address;
      if (!silent) { w.go(1); }
      return;
    }
    holder.appendChild(el("p", "rsv-note", "Филиал в городе " + esc(city) + ":"));
    var bg = el("div", "rsv-grid c2");
    bg.style.marginTop = "12px";
    list.forEach(function (b) {
      var x = el("button", "rsv-opt", esc(b.address));
      if (reservationState.branchId === b.id) x.classList.add("sel");
      x.onclick = function () { choose(b); };
      bg.appendChild(x);
    });
    holder.appendChild(bg);
  }

  // полная сетка времени из метаданных ответа timeslots
  function buildGrid(d) {
    var m = String(d.working_hours || "").match(/(\d{1,2}):(\d{2})\D+(\d{1,2}):(\d{2})/);
    if (!m) return [];
    var step = (d.slot_step_minutes || 15);
    var dur = (d.booking_duration_hours || 3) * 60;
    var start = (+m[1]) * 60 + (+m[2]);
    var close = (+m[3]) * 60 + (+m[4]);
    var last = close - dur;
    var out = [];
    for (var t = start; t <= last; t += step) {
      out.push(("0" + ((t / 60) | 0)).slice(-2) + ":" + ("0" + (t % 60)).slice(-2));
    }
    return out;
  }

  function resetState() {
    Object.keys(reservationState).forEach(function (k) {
      reservationState[k] = (k === "guests") ? 2 : (typeof reservationState[k] === "number" ? null : "");
    });
  }

  // ---- публичный API + автозапуск ----------------------------------------
  var ReservationWizard = {
    state: reservationState,
    init: function (mountEl) {
      if (!mountEl) return null;
      injectCSS();
      return new Wizard(mountEl);
    }
  };

  global.ReservationWizard = ReservationWizard;

  document.addEventListener("DOMContentLoaded", function () {
    var auto = document.getElementById("reservation-wizard") ||
               document.querySelector("[data-reservation-wizard]");
    if (auto) ReservationWizard.init(auto);
  });

})(window);
