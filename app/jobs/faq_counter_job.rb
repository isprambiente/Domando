class FaqCounterJob < ApplicationJob
  queue_as :default

  def perform(faq: '')
    faq.update(counter: faq.counter + 1) if faq.present?
  end
end
