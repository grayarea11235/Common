from urllib.parse import urlparse

import os
import pygit2

from github import Github

def get_repo_list():
    token = os.environ['GITHUB_TOKEN']

    g = Github(token)

    root_path = '/media/cpd/8067-3833/GithubBackup/'
    
    for repo in g.get_user().get_repos():
        print('Repo name is {} and url is {}'.format(repo.name, repo.url))
        dest_path = os.path.join(root_path, repo.name)

        print('Cloning to {}'.format(dest_path)) 
        repoClone = pygit2.clone_repository(repo.git_url, dest_path)
 
        # We have to use Pygit2
        # https://stackoverflow.com/questions/49458329/create-clone-and-push-to-github-repo-using-pygithub-and-pygit2


def main():
    #repoClone = pygit2.clone_repository(repo.git_url, '/path/to/clone/to')
    get_repo_list()

    #clone = pygit2.clone_repository(url, '/home/cpd/temp/gittest/Common')


if __name__ == '__main__':
    main()
