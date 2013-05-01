module Jobs
  class SendOrderConfirmation
    @queue = :order_confirmation_emails
    def self.perform(order_id, invoice_id)
      Notifier.order_confirmation(order_id, invoice_id).deliver
    end
  end

  class SendOrderCancelledNotification
    @queue = :order_cancelled_notification_emails
    def self.perform(order_id)
      Notifier.order_cancelled_notification(order_id).deliver
    end
  end

  class SendPasswordResetInstructions
    @queue = :password_reset_emails
    def self.perform(user_id)
      Notifier.password_reset_instructions(user_id).deliver
    end
  end

  class SendSignUpNotification
    @queue = :signup_notification_emails
    def self.perform(user_id)
      Notifier.signup_notification(user_id).deliver
    end
  end

  class SendLaunchEmail
    @queue = :launch_emails
    def self.perform(user_id)
      Notifier.launch_email(user_id).deliver
    end
  end

  class SendRegistrationEmail
    @queue = :registration_emails
    def self.perform(user_id)
      Notifier.registration_email(user_id).deliver
    end
  end
end
