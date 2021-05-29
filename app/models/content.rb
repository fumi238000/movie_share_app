class Content < ApplicationRecord
  has_many :materials, dependent: :destroy
  has_many :makes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :users

  validates :title, presence: true, length: { in: 1..16, allow_blank: true }
  validates :subtitle, presence: true, length: { in: 1..32, allow_blank: true }
  # TODO: movie_urlバリデージョン実装時に実装する
  # validates :movie_url, presence: true
  validates :comment, presence: true, length: { in: 1..32, allow_blank: true }
  validates :point, presence: true, length: { in: 1..32, allow_blank: true }
  # validates recommend_status:, presence: true

  enum recommend_status: { general: 0, recommend: 1 }
  # TODO: サムネイル画像のURLを保存するかどうか検討
  # mount_uploader :movie_thumbnail, MovieThumbnailUploader

  # お気に入り判定
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 動画保存処理
  before_save do
    format_url = YoutubeUrlFormatter.url_format(movie_url)
    if format_url.present?
      self.movie_url = format_url
    else
      # 失敗した場合はバリデーションエラーを出す
      self.errors.add(:movie_url, "YouTubeのURL以外は無効です")
      throw(:abort)
    end
  end
end
