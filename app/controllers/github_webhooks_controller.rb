class GithubWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  GITHUB_USER = 'sunny-b'
  GITHUB_BRANCH = 'master'

  def deploy
    if params.fetch(:sender, {}).fetch(:login) == GITHUB_USER && params.fetch(:ref, "").include?(GITHUB_BRANCH)
      deploy_cmd
      return render status: :ok, json: @controller.to_json
    end

    render status: :bad_request, json: {}.to_json
  end

  private

  def deploy_cmd
    `#{Rails.root.join('deploy.sh').to_s}`
  end
end
