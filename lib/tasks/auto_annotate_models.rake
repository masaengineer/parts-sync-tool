if Rails.env.development?
  require "annotate"

  # モデル注釈のデフォルト設定
  task :set_annotation_options do
    Annotate.set_defaults(
      "position_in_class"         => "before",
      "position_in_fixture"       => "before",
      "position_in_factory"       => "before",
      "show_foreign_keys"         => "true",
      "show_indexes"              => "true",
      "simple_indexes"            => "false",
      "model_dir"                 => "app/models",
      "exclude_tests"             => "false",
      "exclude_fixtures"          => "false",
      "exclude_factories"         => "false",
      "ignore_model_sub_dir"      => "false",
      "skip_on_db_migrate"        => "false", # ここを false に設定
      "format_bare"               => "true",
      "format_rdoc"               => "false",
      "format_markdown"           => "false",
      "sort"                      => "false",
      "force"                     => "false",
      "trace"                     => "false"
    )
  end

  # マイグレーション後に自動実行するタスクを設定
  Annotate.load_tasks

  # マイグレーション後に実行されるフック
  task :auto_annotate_models do
    system "bundle exec annotate --models"
  end

  # db:migrateタスクの後に自動注釈を実行
  Rake::Task["db:migrate"].enhance do
    Rake::Task["annotate_models"].invoke if Rails.env.development?
  end

  # db:rollbackタスクの後に自動注釈を実行
  Rake::Task["db:rollback"].enhance do
    Rake::Task["annotate_models"].invoke if Rails.env.development?
  end
end
