class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, Course, teacher_id: user.id
    can :read, Section do |section|
      !section.course.enrollments.find(:first, conditions: ["user_id = ?", user.id]).nil?
    end
    can :read, Subsection do |subsection|
      !subsection.course.enrollments.find(:first, conditions: ["user_id = ?", user.id]).nil?
    end
    can :manage, User, id: user.id
    can :create, Wish unless user.new_record?
    can :manage, Wish, user_id: user.id
    can :manage, Order, user_id: user.id
    can :manage, Fund, user_id: user.id
    can :manage, Enrollment, user_id: user.id
    can :manage, Section, course: { teacher_id: user.id }
    can :manage, Subsection, course: { teacher_id: user.id }
    can :manage, Question, course: { teacher_id: user.id }
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
