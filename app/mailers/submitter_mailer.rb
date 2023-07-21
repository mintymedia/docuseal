# frozen_string_literal: true

class SubmitterMailer < ApplicationMailer
  DEFAULT_MESSAGE = %(Het volgende document "%<name>s" is naar u verstuurd:)

  def invitation_email(submitter, message: format(DEFAULT_MESSAGE, name: submitter.submission.template.name))
    @submitter = submitter
    @message = message

    mail(to: @submitter.email,
         subject: 'U bent uitgenodig het volgende document te bekijken')
  end

  def completed_email(submitter, user)
    @submitter = submitter
    @user = user

    mail(to: user.email,
         subject: %(#{submitter.email} heeft document getekend "#{submitter.submission.template.name}" form))
  end

  def documents_copy_email(submitter)
    @submitter = submitter

    Submissions::EnsureResultGenerated.call(@submitter)

    @documents = Submitters.select_attachments_for_download(submitter)

    @documents.each do |attachment|
      attachments[attachment.filename.to_s] = attachment.download
    end

    mail(to: submitter.email, subject: 'Kopie of het getekende document')
  end
end
