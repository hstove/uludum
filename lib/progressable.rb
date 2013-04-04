module Progressable
  def self.included(base)
    base.class_eval do
      has_many :progresses, as: :progressable

      def percent_complete user
        self.progress(user).percent.to_i
      end

      def progress user
        prog = progresses.find_or_create_by(user_id: user.id)
      end
    end
  end
end