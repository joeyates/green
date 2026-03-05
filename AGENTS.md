This is a code linting and formatting library written in Elixir.

<ProjectInformation>
See the following files for more information about the project:

- `README.md`: Project overview
</ProjectInformation>

<Development>
- Use a red/green TDD approach. Write tests before implementing code.
- Use relevant checks to ensure high-quality code (see below).
</Development>

<Plans>
- Plans are stored in `docs/plans`.
- Unless instructed otherwise, create a branch for each plan.
- Unless otherwise instructed, stop after completing each task and wait for further instructions.
</Plans>

<GitCommits>
- Create atomic commits for each completed task.
- Only commit when all checks pass.
- Avoid combining multiple tasks into a single commit.
- Never use `git add -A`, instead, add/remove new and modified files by name.
- Only commit when the user accepts that the task is complete.
- Mark tasks as complete in the plan file before committing.
- Write a clear and concise commit message of 50 characters or less in the imperative mood.
- Include a more detailed description in the commit body, if necessary.
- Wrap the body at 72 characters.
- Do not prefix commit messages as with Conventional Commits.
- Make atomic commits, where possible.
- Do not add `Co-Authored-By` trailers.
</GitCommits>

<Checks>
- `mix format --check-formatted` - Ensure Elixir code follows formatting rules
- `mix test` - Run tests to ensure code correctness
</Checks>
