# Day 1

## 1 Submitting Files to Git

We’ve walked through the steps required to add and commit files locally, then add them to a remote repository. Now it’s time for you to try it yourself! Follow the steps below to create files, track them and push them to GitHub.
1.1 MVP

We want to create a homework directory structure and repo similar to the classnotes repo you cloned earlier.

Remember, in everything that follows, never create a repo or clone one inside an existing repo. Fortunately Github Desktop will warn you if you’re about to do this but it’s still possible to override it and nest the repos anyway, so take care!

Working locally on your own computer:

    Create a folder in the CodeClan directory where you’re keeping your work files.
    Initialise a Git repository in the new homework folder.
    Create a week_01 folder, then a day_1 folder inside that.
    Create a couple of .txt files in the folder.
    Commit the files.
    Make a change to each file.
    Commit the changes.
    Publish your repository on Github. This will be the repository all of your homework gets pushed to, the instructors will pull your work every morning to see how you got on. Call the repo codeclan_homework_yourname (just like the folder) and remember to make it public!
    Make some more changes to your files (or even add more) and practice committing and pushing your work.

## 1.2 Extension

Investigate how to ignore files when working with Git. You can find the official documentation here, but there are lots of resources available which are more user-friendly. This can be useful you want to hide things like login credentials or local configuration details from public view. When you’ve read the documentation:

    Create a .gitignore file in the root level (topmost layer) of your homework folder (not week_01/day_1)
    Tell it to ignore a file called file_to_ignore.txt
    Stage it, commit it and push it to the remote
    Create file_to_ignore.txt
    Add some text to it
    Check that your new file isn’t being picked up in Github Desktop.

If you’ve set up .gitignore properly you should be able to do whatever you like to file_to_ignore.txt without Git caring!


## Solution
1.2 solution - added 'week_01/day_1/file_to_ignore.txt' to gitignore file
