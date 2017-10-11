plan touch::promote([String] $tier = 'dev') {
  $node = "db.${tier}.vm"
  run_task('touch::noop', [$node], 'files' => ['/etc/postgres/trigger'])
}
