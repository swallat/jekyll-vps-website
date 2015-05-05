module FileStrategy
  # Pretend we don't have a repository cache.
  def test
    false
  end

  # Ensure the repository path exists.
  def check
    context.execute :mkdir, "-p", repo_path
  end

  # Pretend we've cloned the repository.
  def clone
    true
  end

  # Create and upload a package of the local directory as an update.
  def update
    # Ensure a local `tmp` directory exists.
    `mkdir -p #{File.dirname(path)}`

    # Package the local directory, ignoring unnecessary files.
    `tar -zcf #{path} --exclude .git --exclude _site --exclude tmp .`

    # Upload the package to the server.
    context.upload! path, "/#{path}"

    # Remove the package locally.
    `rm #{path}`
  end

  # Extract the uploaded package to the release path and remove.
  def release
    # Ensure the release directory exists on the server.
    context.execute :mkdir, "-p", release_path

    # Extract the uploaded package to the release directory.
    context.execute :tar, "-xmf" "/#{path}", "-C", release_path

    # Remove the package from the server.
    context.execute :rm, "/#{path}"
  end

  # Use the latest repository SHA as the revision.
  def fetch_revision
    `git log --pretty=format:'%h' -n 1 HEAD`
  end

  protected

  # Helper method for the directory package path.
  def path
    "tmp/#{fetch(:application)}.tar.gz"
  end
end
