def eq job
  Rails.configuration.queue << job
end

def mailer clazz, method, *args
  job = Afterparty::MailerJob.new(clazz, method, *args)
  eq job
end

def jobber clazz, method, *args
  job = Afterparty::BasicJob.new(clazz, method, *args)
  eq job
end