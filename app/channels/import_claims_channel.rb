class ImportClaimsChannel < ApplicationCable::Channel
  def subscribed
    return if params[:importId].blank?
    # TODO: Right now anyone can subscribe to the channel if they know the job_id
    # That's really hard to guess (non-sequential UUID), but still not great.
    stream_from "#{params[:importId]}"
    logger.info("Subscribed to #{params[:importId]}")
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
