class ConfirmationsController < Devise::ConfirmationsController
  protected
    def after_confirmation_path_for(resource_name, resource)
      @default_templates = Event.where(template: 0)
      @default_templates.each do |template|
        template.dup_as_template (current_user)
      end
      after_sign_in_path_for(resource)
    end
end