class TestJob
  attr_accessor :execute_at, :mail, :clazz, :method, :args
  def initialize time=nil
    # @mail = UserMailer.welcome_email(User.find(1))
    @clazz = UserMailer
    @method = :welcome_email
    @args = [User.find(1)]
    @execute_at = time
    
  end
  
  def run
    @mail = @clazz.send @method, *@args
    @mail.deliver
    ap "running a job!"
  end

  def description
    "Mailer: #{@clazz}. Method: #{@method}. Args: #{@args}"
  end
end