module Paranoia
  def self.included(klazz)
    klazz.extend Query
  end

  module Query
    def paranoid? ; true ; end

    def only_deleted
      scoped.tap { |x| x.default_scoped = false }.where(:deleted => true)
    end
    alias :deleted :only_deleted

    def with_deleted
      scoped.tap { |x| x.default_scoped = false }
    end
  end

  def destroy
    _run_destroy_callbacks { delete }
  end

  def delete
    update_attribute_or_column(:deleted, true) if !deleted? && persisted?
    freeze
  end

  def restore!
    update_attribute_or_column :deleted, false
  end

  def destroyed?
    !!self.deleted
  end
  alias :deleted? :destroyed?

  private

  def update_attribute_or_column(*args)
    update_attribute(*args)
  end
end

class ActiveRecord::Base
  def self.acts_as_paranoid
    alias_method :destroy!, :destroy
    alias_method :delete!,  :delete
    include Paranoia
    default_scope :conditions => { :deleted => false }
  end

  def self.paranoid? ; false ; end
  def paranoid? ; self.class.paranoid? ; end

  # Override the persisted method to allow for the paranoia gem.
  # If a paranoid record is selected, then we only want to check
  # if it's a new record, not if it is "destroyed".
  def persisted?
    paranoid? ? !new_record? : super
  end
end
