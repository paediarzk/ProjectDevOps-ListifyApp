package com.example.listify_app;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.os.Bundle;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import com.example.listify_app.Model.ToDoModel;
import com.example.listify_app.Utils.DatabaseHandler;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class AddNewTask extends BottomSheetDialogFragment {

    public static final String TAG = "ActionBottomDialog";

    private EditText taskTitle, taskDescription;
    private TextView taskDate, taskTime;
    private Button saveTaskButton;

    private DatabaseHandler db;
    private Calendar calendar = Calendar.getInstance();

    public static AddNewTask newInstance() {
        return new AddNewTask();
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NORMAL, R.style.DialogStyle);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.new_task, container, false);
        getDialog().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        taskTitle = view.findViewById(R.id.newTaskTitle);
        taskDescription = view.findViewById(R.id.newTaskDescription);
        taskDate = view.findViewById(R.id.newTaskDate);
        taskTime = view.findViewById(R.id.newTaskTime);
        saveTaskButton = view.findViewById(R.id.saveTaskButton);

        db = new DatabaseHandler(getActivity());
        db.openDatabase();

        Bundle bundle = getArguments();
        if (bundle != null) {
            // Pre-fill the fields if arguments are present (for editing)
            taskTitle.setText(bundle.getString("title", ""));
            taskDescription.setText(bundle.getString("description", ""));
            taskDate.setText(bundle.getString("date", ""));
            taskTime.setText(bundle.getString("time", ""));
        }

        // Date Picker
        taskDate.setOnClickListener(v -> showDatePickerDialog());

        // Time Picker
        taskTime.setOnClickListener(v -> showTimePickerDialog());

        // Enable Save Button
        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                enableSaveButton();
            }

            @Override
            public void afterTextChanged(Editable s) {}
        };

        taskTitle.addTextChangedListener(textWatcher);
        taskDescription.addTextChangedListener(textWatcher);

        // Save Task Button
        saveTaskButton.setOnClickListener(v -> {
            ToDoModel task = new ToDoModel();
            task.setTitle(taskTitle.getText().toString());
            task.setDescription(taskDescription.getText().toString());
            task.setDate(taskDate.getText().toString());
            task.setTime(taskTime.getText().toString());
            task.setStatus(0);

            // Check if the task already has an ID (for editing)
            if (bundle != null && bundle.containsKey("id")) {
                task.setId(bundle.getInt("id"));
                db.updateTask(task);
            } else {
                db.insertTask(task);
            }

            dismiss();
        });

        enableSaveButton();
    }


    private void enableSaveButton() {
        boolean isTitleFilled = !taskTitle.getText().toString().trim().isEmpty();
        boolean isDescriptionFilled = !taskDescription.getText().toString().trim().isEmpty();
        boolean isDateFilled = !taskDate.getText().toString().trim().isEmpty();
        boolean isTimeFilled = !taskTime.getText().toString().trim().isEmpty();


        boolean isEnabled = isTitleFilled && isDescriptionFilled && isDateFilled && isTimeFilled;
        saveTaskButton.setEnabled(isEnabled);
        saveTaskButton.setTextColor(isEnabled ?
                ContextCompat.getColor(requireContext(), R.color.ghost_white) :
                ContextCompat.getColor(requireContext(), android.R.color.darker_gray));
    }

    private void showDatePickerDialog() {
        DatePickerDialog datePickerDialog = new DatePickerDialog(requireContext(),
                (view, year, month, dayOfMonth) -> {
                    calendar.set(Calendar.YEAR, year);
                    calendar.set(Calendar.MONTH, month);
                    calendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
                    updateDateLabel();
                },
                calendar.get(Calendar.YEAR),
                calendar.get(Calendar.MONTH),
                calendar.get(Calendar.DAY_OF_MONTH));
        datePickerDialog.show();
    }

    private void showTimePickerDialog() {
        TimePickerDialog timePickerDialog = new TimePickerDialog(requireContext(),
                (view, hourOfDay, minute) -> {
                    calendar.set(Calendar.HOUR_OF_DAY, hourOfDay);
                    calendar.set(Calendar.MINUTE, minute);
                    updateTimeLabel();
                },
                calendar.get(Calendar.HOUR_OF_DAY),
                calendar.get(Calendar.MINUTE),
                true);
        timePickerDialog.show();
    }

    private void updateDateLabel() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
        taskDate.setText(dateFormat.format(calendar.getTime()));
        enableSaveButton();
    }

    private void updateTimeLabel() {
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm", Locale.getDefault());
        taskTime.setText(timeFormat.format(calendar.getTime()));
        enableSaveButton();
    }

    @Override
    public void onDismiss(@NonNull DialogInterface dialog) {
        Activity activity = getActivity();
        if (activity instanceof DialogCloseListener)
            ((DialogCloseListener) activity).handleDialogClose(dialog);
    }
}