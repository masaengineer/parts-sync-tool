module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Parts Sync"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

    def default_meta_tags
      {
        site: 'Parts Sync',
        title: 'カーパーツ売上管理システム',
        reverse: true,
        charset: 'utf-8',
        description: 'カーパーツ売上管理システム',
        keywords: 'カーパーツ,売上管理,システム',
        canonical: request.original_url,
        separator: '|',
        icon: [
          { href: image_url("logo/favicon.svg"), sizes: "60x60" },
          { href: image_url("logo/favicon.png"), rel: "icon", sizes: "90x90", type: "image/png" },
        ],
        og: {
          site_name: :site,
          title: :title,
          description: :description,
          type: 'website',
          url: request.original_url,
          image: image_url('ogp.png'),
          local: 'ja-JP'
        },
        twitter: {
          card: 'summary_large_image',
          site: '@',
          image: image_url('ogp.png')
        }
      }
    end
end
