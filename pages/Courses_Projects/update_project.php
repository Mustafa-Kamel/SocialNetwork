<?php
/**
 * This script is used to update an exist project in the database
 * Updates the data of specific project (ID) (one row) in the `Projects` table from the project form when the form is submitted
 *
 * php version 7.0.8
 * @version 2.0.0
 * @author Mustafa Kamel   May 5, 2017
 * @method POST
 * 
 * @param integer id        id of the project to be updated
 * @param integer supervisor supervisor of the project to be updated
 * @param string idea       idea of the project to be updated
 * @param string name       name of the project to be updated
 * @param string abstract   abstract description of the project to be updated
 * @param string pic        picture url of the project to be updated
 * @param string st_date    starting date of the project to be updated
 * @param string end_date   end date of the project to be updated
 * @param integer tag       teg of the project to be updated
 */

require_once ("CoursesProjectsModel.php");
require_once ("../../includes/session.php");
require_once("../../includes/db_connection.php");
require_once("../../includes/functions.php");
require_once("../../includes/form_functions.php");

confirm_logged_in();
confirm_admin();

global $connection;
// START FORM PROCESSING
if (isset($_POST['submit'])) { // Form has been submitted.
	$errors = array();
	// perform validations on the form data
	$required_fields = array('supervisor', 'idea', 'name', 'abstract', 'pic', 'st_date', 'end_date', 'tag');
	$errors = array_merge($errors, check_required_fields($required_fields));
	$fields_max_lengths = array('idea' => 450, 'name' => 45, 'abstract' => 1000, 'pic' => 45);
	$errors = array_merge($errors, check_max_field_lengths($fields_max_lengths));
	$fields_min_lengths = array('idea' => 10, 'name' => 3, 'abstract' => 20, 'pic' => 10, 'st_date'=> 6, 'end_date'=>6);
	$errors = array_merge($errors, check_min_field_lengths($fields_min_lengths));
	$pid = trim(mysql_prep($_POST['id']));
	$supervisor = trim(mysql_prep($_POST['supervisor']));
	$idea = trim(mysql_prep($_POST['idea']));
	$name = trim(mysql_prep($_POST['name']));
	$abstract = trim(mysql_prep($_POST['abstract']));
	$pic = trim(mysql_prep($_POST['pic']));
	$st_date = trim(mysql_prep($_POST['st_date']));
	$end_date = trim(mysql_prep($_POST['end_date']));
	$tag = trim(mysql_prep($_POST['tag']));

	if ( empty($errors) ) {
		//check if course already exist
		$query = "SELECT `idProjects` FROM `Projects` WHERE `name` = ?";
		$check_project_stmt = mysqli_prepare($connection, $query);
		mysqli_stmt_bind_param($check_project_stmt, "s", $name);
		mysqli_stmt_execute($check_project_stmt);
		$result = mysqli_stmt_get_result($check_project_stmt);
		mysqli_stmt_close($check_project_stmt);
		
		if (mysqli_num_rows($result) > 1) {//another project with the same name is found in the database
			$message = "project Already exist.";
		} else {//project is unique, then update it
            if (update_project($pid, $supervisor, $idea, $name, $abstract, $pic, $st_date, $end_date, $tag)) {
                $message = "project data has been updated successfully";
            } else {
                $message = "An error has been occurred while updating the project data!";
            }
        }
	} else {
		$message = "There were " . count($errors) . " errors in the form.";
	}
} else {//Form has not been submitted.
	if (isset($_GET['id']) && (int) $_GET['id'] > 0) {//id of the selected project to be updated
		$id = (int) $_GET['id'];
		$project = get_project_by_id ($id);
		if (count($project) > 0) {//project is found in the database then fill the form with its data to be updated
            $supervisor = $project['Supervisor'];
            $idea = $project['Idea'];
	        $name = $project['name'];
	        $abstract = $project['abstract'];
	        $pic = $project['Picture_URL'];
	        $st_date = $project['dateStarted'];
	        $end_date = $project['dateEnded'];
	        $tag = $project['tag'];
		} else { //project is not found
			$message = "An error has been occurred, project is not found!";
            $supervisor = "";
            $idea = "";
	        $name = "";
	        $abstract = "";
	        $pic = "";
	        $st_date = "";
	        $end_date = "";
	        $tag = "";
		}
	} else {//wrong id
		$message = "Invalid ID, project is not found!";
        $supervisor = "";
        $idea = "";
	    $name = "";
	    $abstract = "";
	    $pic = "";
	    $st_date = "";
	    $end_date = "";
	    $tag = "";
	}
}
?>
<?php include("../../includes/header_admin.php"); ?>
<table id="structure">
	<tr>
		<td id="page">
			<h2>Update Project</h2>
			<?php if (!empty($message)) {echo "<p class=\"message\">" . $message . "</p>";} ?>
			<?php if (!empty($errors)) { display_errors($errors); } ?>
			<form action="update_project.php" method="post">
			<table>
				<tr>
					<td>Supervisor:</td>
					<td><input type="text" name="supervisor" maxlength="45" value="<?php echo htmlentities($supervisor); ?>"/></td>
				</tr>
				<tr>
					<td>Idea:</td>
					<td><textarea rows="5" cols="22" name="idea" maxlength="450" ><?php echo htmlentities($idea); ?></textarea></td>
				</tr>
				<tr>
					<td>Name:</td>
					<td><input type="text" name="name" maxlength="45" value="<?php echo htmlentities($name); ?>" /></td>
				</tr>
				<tr>
					<td>Abstract:</td>
					<td><textarea rows="5" cols="22" name="abstract" maxlength="1000" /><?php echo htmlentities($abstract); ?></textarea></td>
				</tr>
				<tr>
					<td>Picture URL:</td>
					<td><input type="url" name="pic" maxlength="45" value="<?php echo htmlentities($pic); ?>" /></td>
				</tr>
				<tr>
					<td>Starting Date:</td>
					<td><input type="date" name="st_date" maxlength="45" value="<?php echo htmlentities($st_date); ?>" /></td>
				</tr>
				<tr>
					<td>End Date:</td>
					<td><input type="date" name="end_date" maxlength="45" value="<?php echo htmlentities($end_date); ?>" /></td>
				</tr>
				<tr>
					<td>Tag:</td>
					<td><input type="number" name="tag" maxlength="45" value="<?php echo htmlentities($tag); ?>" /></td>
				</tr>
				<tr>
					<td><input type="hidden" name="id" value="<?php echo htmlentities($id); ?>" /></td>
					<td colspan="2"><input type="submit" name="submit" value="Update Project" /></td>
				</tr>
			</table>
			</form>
		</td>
	</tr>
</table>
<?php include("../../includes/footer.php"); ?>