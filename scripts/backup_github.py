from github import Github
import os
import pygit2


def backup_repos():
    '''
    This depends on the github toten being set in the environment
    variable GITHUB_TOKEN.
    '''
    token = os.environ['GITHUB_TOKEN']

    git_hub = Github(token)

    root_path = '/media/cpd/8067-3833/GithubBackup/'
    for repo in git_hub.get_user().get_repos():
        print('Repo name is {} and url is {}'.format(repo.name, repo.url))
        dest_path = os.path.join(root_path, repo.name)

        print('Cloning to {}'.format(dest_path)) 
        repo_clone = pygit2.clone_repository(repo.git_url, dest_path)
        print(repo_clone)

        # We have to use Pygit2
        # https://stackoverflow.com/questions/49458329/create-clone-and-push-to-github-repo-using-pygithub-and-pygit2


def main():
    ''' Main entry point. '''
    backup_repos()


if __name__ == '__main__':
    main()
