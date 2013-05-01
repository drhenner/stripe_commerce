require 'open-uri'

class Notifier < ActionMailer::Base
  default :from => "#{ I18n.t(:company) } <no-reply@#{ I18n.t(:company_domain) }>"

  def launch_email(user_id)
    @user = User.where(:id => user_id).first
    @key  = UsersNewsletter.unsubscribe_key(@user.email)

    mail(:to => @user.email_address_with_name,
         :subject => "#{ I18n.t(:company) } Newsletter")
  end

  def order_cancelled_notification(order_id)
    @order  = Order.find(order_id)
    @user   = @order.user
    @key    = UsersNewsletter.unsubscribe_key(@user.email)
    mail(:to => @order.email,
     :subject => "Order Cancelled")
  end

  def order_confirmation(order_id,invoice_id)
    @invoice = Invoice.find(invoice_id)
    @order  = Order.find(order_id)
    @user   = @order.user
    @key    = UsersNewsletter.unsubscribe_key(@user.email)
    @url    = root_url
    @site_name = 'site_name'
    mail(:to => @order.email,
         :subject => "Order Confirmation")
  end

  def password_reset_instructions(user_id)
    @user = User.find(user_id)
    @key  = UsersNewsletter.unsubscribe_key(@user.email)
    @url  = edit_customer_password_reset_url(:id => @user.perishable_token)
    mail(:to => @user.email,
         :subject => "Reset Password Instructions")
  end

  def registration_email(user_id)
    @user = User.where(:id => user_id).first
    @key  = UsersNewsletter.unsubscribe_key(@user.email)

    mail(:to => @user.email_address_with_name,
         :subject => "Thank you for Registering!")
  end

  def send_file_to_list(export_doc_id, list, subject)
    export_doc = ExportDocument.find(export_doc_id)
    attachments[export_doc.doc_file_name] = open(export_doc.doc.url) {|f| f.read }
    mail(:to => [list],
         :subject => subject)
  end

  # Simple Welcome mailer
  # => CUSTOMIZE FOR YOUR OWN APP
  #
  # @param [user] user that signed up
  # => user must respond to email_address_with_name and name
  def signup_notification(recipient_id)
    @user = User.find(recipient_id)
    @key  = UsersNewsletter.unsubscribe_key(@user.email)

    mail(:to => @user.email_address_with_name,
         :subject => "Thank you for Subscribing!")
  end

end
