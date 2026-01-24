module NavigationHelper
  # 指定した base_path 配下のページかどうかを判定する
  # ナビゲーションで
  # 「親ページ＋その配下すべて」を active 扱いしたいときに使う
  def nav_active?(base_path)
    request.path.start_with?(base_path)
  end

  # ナビゲーション用 link の class を返す
  def nav_link_class(base_path)
    # 共通のベースクラス
    base = %w[
      btn btn-ghost border-0 shadow-none
      hover:bg-transparent focus:outline-none focus:ring-0
      active:bg-transparent flex items-center gap-2
    ]

    if nav_active?(base_path)
      # 現在表示中
      base + %w[text-primary border-b-2 border-primary rounded-none pb-1]
    else
      # 非表示中
      base + %w[hover:text-primary]
    end
  end
end
