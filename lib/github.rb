require "graphql/client"
require "graphql/client/http"
class QueryExecutionError < StandardError; end

module Github
    HTTP = GraphQL::Client::HTTP.new("https://api.github.com/graphql") do
        def headers(context)
        { "Authorization" => "Bearer 6da3ae15605325a3c286660818720277dc91e90a" }
        end
    end
    Schema = GraphQL::Client.load_schema(HTTP)
    Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

    class User
        UserProfileQuery = Github::Client.parse <<-'GRAPHQL'
            query($username: String!, $user_id: ID!) {
                user(login: $username) {
                    name
                    url
                    avatarUrl
                    contributionsCollection {
                        totalIssueContributions
                        totalPullRequestContributions
                        totalPullRequestReviewContributions
                        totalCommitContributions
                        commitContributionsByRepository(maxRepositories: 99) {
                            repository {
                                name
                                url
                                languages(first: 99) {
                                    nodes {
                                        color
                                        name
                                    }
                                }
                                defaultBranchRef {
                                    target {
                                        ... on Commit {
                                            history(author: {id: $user_id}) {
                                                totalCount
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            GRAPHQL
        UserIdQuery = Github::Client.parse <<-'GRAPHQL'
            query($username: String!) {
                user(login: $username) {
                    id
                }
            }
            GRAPHQL
        def self.find(username, user_id)
            response = Github::Client.query(UserProfileQuery, variables: {username: username, user_id: user_id})
            if response.errors.any?
                raise QueryExecutionError.new(response.errors[:data].join(", "))
            else
                response.data.user
            end
        end
        def self.get_user_id(username)
            response = Github::Client.query(UserIdQuery, variables: {username: username})
            if response.errors.any?
                raise QueryExecutionError.new(response.errors[:data].join(", "))
            else
                response.data.user
            end
        end
    end
end
