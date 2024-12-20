//
//  TodoListView.swift
//  FastAPP1
//
//  Created by PKW on 11/27/24.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        WriteBtn {
            VStack {
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            todoListViewModel.navigationRightBtnTapped()
                        },
                        rightBtnType: todoListViewModel.navigationBarRightBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                
                TitleView()
                    .padding(.top, 20)
                
                if todoListViewModel.todos.isEmpty {
                    AnnouncementView()
                } else {
                    TodoListContentView()
                        .padding(.top, 20)
                }
            }
//            .modifier(WriteBtnViewModifire(action: { pathModel.paths.append(.todoView) }))
            .alert(
                "To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
                isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
            ) {
                Button("삭제", role: .destructive) {
                    todoListViewModel.removeBtnTapped()
                }
                Button("취소", role: .cancel) { }
            }
            .onChange(
                of: todoListViewModel.todos,
                perform: { todos in
                    homeViewModel.setTodoCount(todos.count)
                }
            )
        } action: {
            pathModel.paths.append(.todoView)
        }
    }
}

// MARK - TodoList 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
   
    fileprivate var body: some View {
        
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
            } else {
                Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoList 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            Text("“매일 아침 8시 운동가라고 알려줘“")
            Text("“내일 8시 수강 신청하라고 알려줘”")
            Text("“1시 반 점심약속 리마인드 해줘”")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(.customGray2)
    }
}

// MARK: - Todo 작성 버튼 뷰
private struct WriteTodoBtnView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: { pathModel.paths.append(.todoView) },
                    label: { Image("writeBtn") }
                )
            }
        }
    }
}

// MARK: - TodoList 컨텐츠 뷰
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                // 구분선
                Rectangle()
                    .fill(.customGray0)
                    .frame(height: 1)
                
                ForEach(todoListViewModel.todos, id: \.self) { todo in
                    TodoCellView(todo: todo)
                }
            }
        }
    }
}

// MARK: - Todo 셀 뷰
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: TodoModel
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: TodoModel
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button(
                        action: { todoListViewModel.selectedBoxTapped(todo) },
                        label: {
                            todo.selected ? Image("selectedBox") : Image("unSelectedBox") }
                    )
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundStyle(todo.selected ? .customIconGray : .customBlack)
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundStyle(.customIconGray)
                }
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button(
                        action: {
                            isRemoveSelected.toggle()
                            todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                        } ,
                        label: { isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox") }
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        
        // 구분선
        Rectangle()
            .fill(.customGray0)
            .frame(height: 1)
    }
}

#Preview {
    TodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
}
 
