$(document).ready(function() {
    $.getJSON("https://api.github.com/repos/marcelovca90/marcelovca90.github.io/commits/master", function(data, status){
        var commit_id = data.sha, commit_id_short = commit_id.substring(0,7);
        var href = `<a href="https://github.com/marcelovca90/marcelovca90.github.io/commit/${commit_id}">${commit_id_short}</a>`;
        $("#last_update").append(` (${href})`);
      });
});