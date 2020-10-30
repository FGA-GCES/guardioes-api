class VigilanceMailer < ActionMailer::Base
  default from: 'proepi.desenvolvimento@gmail.com'
  layout 'mailer'

  def covid_vigilance_email(survey, user)
    @survey = survey
    @user = user
    
    @date = @user.birthdate.strftime("%d, %m, %Y")
    @date.gsub!(', ', '/')

    @symptoms = []
    @survey.symptom.each do |symptom|
      @symptoms.append Symptom.where("code = ?", symptom).first
    end

    if user.group_id
      group_manager = user.group.group_manager

      email = mail()
      email.from = 'ProEpi <proepi.desenvolvimento@gmail.com>'
      email.to = group_manager.group_name + ' <' + group_manager.vigilance_email + '>'
      email.subject = '[VIGILANCIA ATIVA] Novo usuário com suspeita'

      return email
    end
  end
end
  
