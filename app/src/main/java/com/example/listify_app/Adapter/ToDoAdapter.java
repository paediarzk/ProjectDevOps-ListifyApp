package com.example.listify_app.Adapter;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.example.listify_app.AddNewTask;
import com.example.listify_app.MainActivity;
import com.example.listify_app.Model.ToDoModel;
import com.example.listify_app.R;
import com.example.listify_app.Utils.DatabaseHandler;

import java.util.ArrayList;
import java.util.List;

public class ToDoAdapter extends RecyclerView.Adapter<ToDoAdapter.ViewHolder> {

    private List<ToDoModel> todoList = new ArrayList<>();
    private MainActivity activity;
    private DatabaseHandler db;

    public ToDoAdapter(DatabaseHandler db,  MainActivity activity) {
        this.db = db;
        this.activity = activity;
    }

    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.task_layout, parent, false);
        return new ViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        db.openDatabase();
        ToDoModel item = todoList.get(position);

        // Bind data to the views
        holder.title.setText(item.getTitle());
        holder.taskCheckBox.setChecked(toBoolean(item.getStatus()));
        holder.description.setText(item.getDescription());
        holder.date.setText(item.getDate());
        holder.time.setText(item.getTime());
        holder.taskCheckBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked) {
                    db.updateStatus(item.getId(),1);
                }
                else {
                    db.updateStatus(item.getId(), 0);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return todoList.size();
    }

    public void setTasks(List<ToDoModel> todoList) {
        this.todoList = todoList;
        notifyDataSetChanged();
    }

    private boolean toBoolean(int n) {
        return n != 0;
    }

    public Context getContext() {
        return activity;
    }

    public void deleteItem(int position) {
        ToDoModel item = todoList.get(position);
        db.deleteTask(item.getId());
        todoList.remove(position);
        notifyItemRemoved(position);
    }

    public void editItem(int position) {
        ToDoModel item = todoList.get(position);
        Bundle bundle = new Bundle();

        bundle.putInt("id", item.getId());
        bundle.putString("title", item.getTitle());
        bundle.putString("description", item.getDescription());
        bundle.putString("date", item.getDate());
        bundle.putString("time", item.getTime());

        AddNewTask fragment = new AddNewTask();
        fragment.setArguments(bundle);
        fragment.show(activity.getSupportFragmentManager(), AddNewTask.TAG);
    }




    public static class ViewHolder extends RecyclerView.ViewHolder {
        CheckBox taskCheckBox;
        TextView title, description, date, time;

        ViewHolder(View view) {
            super(view);
            taskCheckBox = view.findViewById(R.id.taskCheckBox);
            title = view.findViewById(R.id.taskTitle);
            description = view.findViewById(R.id.taskDescription);
            date = view.findViewById(R.id.taskDate);
            time = view.findViewById(R.id.taskTime);
        }
    }
}