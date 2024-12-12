# frozen_string_literal: true

module UpcaseName
  def upcase_name
    self.name.upcase
  end
end

::UserProfile.include UpcaseName
