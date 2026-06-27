# Pomodoro Timer — Übersicht widget
# Shares the Task Tracker widget's design system (taupe/brown palette, Lora display type, white pill rows)

refreshFrequency: false

style: '''
  top: 20px
  left: 320px
  font-family: -apple-system, "Helvetica Neue", Helvetica, sans-serif

  * { box-sizing: border-box; }

  .pt-card {
    width: 200px;
    background: transparent;
    border-radius: 12px;
    padding: 8px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
    cursor: grab;
  }
  .pt-card.dragging { cursor: grabbing; }

  .pt-clock {
    position: relative;
    width: 160px;
    height: 160px;
    cursor: pointer;
  }

  .pt-clock-svg {
    width: 100%;
    height: 100%;
    transform: rotate(-90deg);
  }

  .pt-clock-track {
    fill: none;
    stroke: rgba(255,255,255,0.3);
    stroke-width: 8;
  }

  .pt-clock-progress {
    fill: none;
    stroke: #ffffff;
    stroke-width: 8;
    stroke-linecap: round;
    transition: stroke-dashoffset 1s linear;
  }

  .pt-clock-time {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Lora', Georgia, serif;
    font-weight: 700;
    font-size: 32px;
    color: #ffffff;
    text-shadow: 0px 1px 4px rgba(0,0,0,0.25);
  }

  .pt-session-count {
    font-size: 10px;
    color: rgba(255,255,255,0.85);
  }

  .pt-controls {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    width: 100%;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.25s ease;
  }
  .pt-controls.visible { opacity: 1; pointer-events: auto; }

  .pt-btn {
    border: none;
    border-radius: 100px;
    cursor: pointer;
    font-size: 11px;
    font-weight: 500;
    letter-spacing: 0.02em;
    padding: 7px 14px;
    transition: background 0.15s, color 0.15s, opacity 0.15s;
  }

  .pt-btn-secondary {
    background: rgba(255,255,255,0.55);
    color: #6b5f50;
  }
  .pt-btn-secondary:hover { background: #8a7866; color: #ffffff; }

  .pt-btn-primary {
    background: #ffffff;
    color: #8a7866;
    box-shadow: 0px 1px 3px 0px rgba(0,0,0,0.25);
    font-weight: 700;
    padding: 8px 20px;
  }
  .pt-btn-primary:hover { opacity: 0.85; }

  .pt-settings-btn {
    width: 28px; height: 28px;
    border: none;
    border-radius: 50%;
    background: rgba(255,255,255,0.55);
    color: #6b5f50;
    cursor: pointer;
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    transition: background 0.15s, color 0.15s, transform 0.2s ease;
  }
  .pt-settings-btn svg { display: block; width: 13px; height: 13px; }
  .pt-settings-btn:hover { background: #8a7866; color: #ffffff; }
  .pt-settings-btn.open { transform: rotate(45deg); }

  .pt-settings-panel {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding: 8px;
    background: rgba(255,255,255,0.55);
    border-radius: 12px;
    width: 100%;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.25s ease;
  }
  .pt-settings-panel.hidden { opacity: 0; pointer-events: none; }
  .pt-settings-panel:not(.hidden) { opacity: 1; pointer-events: auto; }

  .pt-settings-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 6px;
  }

  .pt-settings-label {
    font-size: 11px;
    color: #6b5f50;
    font-weight: 500;
  }

  .pt-settings-input {
    width: 48px;
    border: 1px solid rgba(0,0,0,0.1);
    background: rgba(255,255,255,0.85);
    border-radius: 100px;
    padding: 4px 8px;
    font-size: 11px;
    text-align: center;
    outline: none;
  }
'''

render: () -> """
  <div class="pt-card" id="ptCard">
    <div class="pt-clock" id="ptClock">
      <svg class="pt-clock-svg" viewBox="0 0 120 120">
        <circle class="pt-clock-track" cx="60" cy="60" r="52" />
        <circle class="pt-clock-progress" id="ptClockProgress" cx="60" cy="60" r="52" />
      </svg>
      <div class="pt-clock-time" id="ptTimer">25:00</div>
    </div>
    <div class="pt-session-count" id="ptSessionCount">Session 1</div>
    <div class="pt-controls" id="ptControls">
      <button class="pt-btn pt-btn-secondary" id="ptResetBtn" title="Reset">Reset</button>
      <button class="pt-btn pt-btn-primary" id="ptStartBtn" title="Start">Start</button>
      <button class="pt-btn pt-btn-secondary" id="ptSkipBtn" title="Skip">Skip</button>
      <button class="pt-settings-btn" id="ptSettingsBtn" title="Settings">
        <svg viewBox="0 0 24 24" fill="currentColor"><path d="m21,10v-1h-1v-2h1v-2h-1v-1h-1v-1h-2v1h-2v-1h-1V1h-4v2h-1v1h-2v-1h-2v1h-1v1h-1v2h1v2h-1v1H1v4h2v1h1v2h-1v2h1v1h1v1h2v-1h2v1h1v2h4v-2h1v-1h2v1h2v-1h1v-1h1v-2h-1v-2h1v-1h2v-4h-2Zm-11,0v-1h4v1h1v4h-1v1h-4v-1h-1v-4h1Z"/></svg>
      </button>
    </div>
    <div class="pt-settings-panel hidden" id="ptSettingsPanel">
      <div class="pt-settings-row">
        <span class="pt-settings-label">Focus (min)</span>
        <input type="number" min="1" max="180" class="pt-settings-input" id="ptFocusInput" />
      </div>
      <div class="pt-settings-row">
        <span class="pt-settings-label">Short break (min)</span>
        <input type="number" min="1" max="60" class="pt-settings-input" id="ptShortInput" />
      </div>
      <div class="pt-settings-row">
        <span class="pt-settings-label">Long break (min)</span>
        <input type="number" min="1" max="60" class="pt-settings-input" id="ptLongInput" />
      </div>
    </div>
  </div>
"""

afterRender: (domEl) ->
  DURATIONS_KEY = 'ptDurations'
  STATE_KEY = 'ptState'
  POSITION_KEY = 'ptPosition'

  MODE_INFO =
    focus: { label: 'Focus',       color: '#bea89a', durationKey: 'focus' }
    short: { label: 'Short Break', color: '#caa05c', durationKey: 'short' }
    long:  { label: 'Long Break',  color: '#9d5727', durationKey: 'long' }

  DEFAULT_DURATIONS = { focus: 25, short: 5, long: 15 }
  CIRCUMFERENCE = 2 * Math.PI * 52

  q = (id) -> domEl.querySelector('#' + id)

  loadDurations = ->
    raw = localStorage.getItem DURATIONS_KEY
    return Object.assign({}, DEFAULT_DURATIONS) unless raw
    parsed = try
      JSON.parse raw
    catch e
      null
    if parsed and parsed.focus and parsed.short and parsed.long
      parsed
    else
      Object.assign({}, DEFAULT_DURATIONS)

  saveDurations = (d) ->
    localStorage.setItem DURATIONS_KEY, JSON.stringify(d)

  durations = loadDurations()

  loadState = ->
    raw = localStorage.getItem STATE_KEY
    fresh = { mode: 'focus', secondsLeft: durations.focus * 60, totalSeconds: durations.focus * 60, running: false, sessionNum: 1 }
    return fresh unless raw
    try
      parsed = JSON.parse raw
      parsed.running = false
      parsed.totalSeconds = parsed.totalSeconds or durations[MODE_INFO[parsed.mode].durationKey] * 60
      parsed
    catch e
      fresh

  state = loadState()
  timerId = null

  saveState = ->
    localStorage.setItem STATE_KEY, JSON.stringify(state)

  pad2 = (n) -> if n < 10 then '0' + n else String(n)

  formatSeconds = (s) ->
    m = Math.floor(s / 60)
    sec = s % 60
    pad2(m) + ':' + pad2(sec)

  render = ->
    q('ptTimer').textContent = formatSeconds(state.secondsLeft)
    q('ptSessionCount').textContent = 'Session ' + state.sessionNum
    q('ptStartBtn').textContent = if state.running then 'Pause' else 'Start'
    progress = q('ptClockProgress')
    fraction = if state.totalSeconds > 0 then state.secondsLeft / state.totalSeconds else 0
    progress.setAttribute 'stroke-dasharray', CIRCUMFERENCE
    progress.setAttribute 'stroke-dashoffset', CIRCUMFERENCE * (1 - fraction)

  nextMode = ->
    if state.mode is 'focus'
      if state.sessionNum % 4 is 0 then 'long' else 'short'
    else
      'focus'

  switchMode = (mode) ->
    stopTimer()
    state.mode = mode
    state.totalSeconds = durations[MODE_INFO[mode].durationKey] * 60
    state.secondsLeft = state.totalSeconds
    state.running = false
    saveState()
    render()

  tick = ->
    state.secondsLeft -= 1
    if state.secondsLeft <= 0
      wasFocus = state.mode is 'focus'
      state.sessionNum += 1 if wasFocus
      switchMode(nextMode())
    else
      saveState()
      render()

  startTimer = ->
    return if timerId
    state.running = true
    saveState()
    render()
    timerId = setInterval(tick, 1000)

  stopTimer = ->
    if timerId
      clearInterval(timerId)
      timerId = null
    state.running = false

  $(domEl).find('#ptStartBtn').on 'click', ->
    if state.running
      stopTimer()
      saveState()
      render()
    else
      startTimer()

  $(domEl).find('#ptResetBtn').on 'click', ->
    stopTimer()
    state.totalSeconds = durations[MODE_INFO[state.mode].durationKey] * 60
    state.secondsLeft = state.totalSeconds
    saveState()
    render()

  $(domEl).find('#ptSkipBtn').on 'click', ->
    wasFocus = state.mode is 'focus'
    state.sessionNum += 1 if wasFocus
    switchMode(nextMode())

  $(domEl).find('#ptSettingsBtn').on 'click', ->
    panel = q('ptSettingsPanel')
    isHidden = panel.classList.contains 'hidden'
    panel.classList.toggle 'hidden'
    q('ptSettingsBtn').classList.toggle 'open', isHidden
    if isHidden
      q('ptFocusInput').value = durations.focus
      q('ptShortInput').value = durations.short
      q('ptLongInput').value = durations.long

  applyDurationChange = (key, inputId) ->
    input = q(inputId)
    val = parseInt(input.value, 10)
    return if isNaN(val) or val < 1
    durations[key] = val
    saveDurations(durations)
    if MODE_INFO[state.mode].durationKey is key and not state.running
      state.totalSeconds = val * 60
      state.secondsLeft = state.totalSeconds
      saveState()
      render()

  $(domEl).find('#ptFocusInput').on 'change', -> applyDurationChange('focus', 'ptFocusInput')
  $(domEl).find('#ptShortInput').on 'change', -> applyDurationChange('short', 'ptShortInput')
  $(domEl).find('#ptLongInput').on 'change', -> applyDurationChange('long', 'ptLongInput')

  hideControls = ->
    q('ptControls').classList.remove 'visible'
    q('ptSettingsPanel').classList.add 'hidden'
    q('ptSettingsBtn').classList.remove 'open'

  $(domEl).find('#ptClock').on 'click', (e) ->
    e.stopPropagation()
    controls = q('ptControls')
    if controls.classList.contains 'visible'
      hideControls()
    else
      controls.classList.add 'visible'

  $(domEl).find('#ptCard').on 'mouseleave', ->
    hideControls()

  # ── Dragging ────────────────────────────────────────────────────────────────
  loadPosition = ->
    raw = localStorage.getItem POSITION_KEY
    return null unless raw
    try
      JSON.parse raw
    catch e
      null

  savedPos = loadPosition()
  if savedPos
    domEl.style.top = savedPos.top + 'px'
    domEl.style.left = savedPos.left + 'px'

  card = q('ptCard')
  dragging = false
  startX = 0
  startY = 0
  origTop = 0
  origLeft = 0

  card.addEventListener 'mousedown', (e) ->
    return if e.target.closest('button, input, select')
    dragging = true
    card.classList.add 'dragging'
    startX = e.clientX
    startY = e.clientY
    rect = domEl.getBoundingClientRect()
    origTop = rect.top
    origLeft = rect.left
    e.preventDefault()

  document.addEventListener 'mousemove', (e) ->
    return unless dragging
    dx = e.clientX - startX
    dy = e.clientY - startY
    domEl.style.left = (origLeft + dx) + 'px'
    domEl.style.top = (origTop + dy) + 'px'

  document.addEventListener 'mouseup', ->
    return unless dragging
    dragging = false
    card.classList.remove 'dragging'
    rect = domEl.getBoundingClientRect()
    localStorage.setItem POSITION_KEY, JSON.stringify({ top: rect.top, left: rect.left })

  render()
