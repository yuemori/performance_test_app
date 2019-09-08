Rails.application.config.middleware.use(
  StackProf::Middleware,
  mode: ENV.fetch('STACK_PROF_MODE', 'wall').to_sym,
  interval: ENV.fetch('STACK_PROF_INTERVAL', 1000),
  raw: true,
  enabled: true,
  path: Rails.root.join('tmp/').to_s,
  save_every: 1,
  save_at_exit: true
)
