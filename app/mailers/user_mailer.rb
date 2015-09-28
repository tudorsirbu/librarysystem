class UserMailer < ApplicationMailer

  def overdue_item_reminder(loan)
    find_user_item(loan)
    if @user.email
      mail(to: @user.email, subject: 'Your loan is overdue!' )
    end
  end

  def loan_expires_soon(loan)
    find_user_item(loan)
    if @user.email
      mail(to: @user.email, subject: 'Your loan expires soon!' )
    end
  end

  def loan_confirmation(loan)
    find_user_item(loan)
    if @user.email
      mail(to: @user.email, subject: 'Your loan has been created.' )
    end
  end

  def item_returned_confirmation(loan)
    find_user_item(loan)
    if @user.email
      mail(to: @user.email, subject: 'Item has been returned.' )
    end
  end

  def item_requested(loan)
    find_user_item(loan)
    if @user.email
      mail(to: @user.email, subject: 'Item has been requested.' )
    end
  end

  def find_user_item(loan)
    @loan = loan
    @user = loan.user
    @item = loan.item
  end

end
