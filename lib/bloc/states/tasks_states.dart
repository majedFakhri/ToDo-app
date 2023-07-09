abstract class TasksStates {}

class TasksInitialStates extends TasksStates {}

class AddTaskState extends TasksStates {}

class EditTaskState extends TasksStates {}

class DeleteTaskState extends TasksStates {}

class SaveTaskState extends TasksStates {}

class GettingTasksState extends TasksStates {}

class RefreshTasksUIState extends TasksStates {}
