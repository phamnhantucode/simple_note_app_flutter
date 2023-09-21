import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValidValue extends CounterState {
  const CounterStateValidValue(int value) : super(value);
}

class CounterStateInvalidValue extends CounterState {
  final String invalidValue;
  const CounterStateInvalidValue(this.invalidValue, int previousValue) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValidValue(0)) {
    on<IncrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(CounterStateInvalidValue(event.value, state.value));
        } else {
          emit(CounterStateValidValue(state.value + integer));
        }
      },
    );
    on<DecrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(CounterStateInvalidValue(event.value, state.value));
        } else {
          emit(CounterStateValidValue(state.value - integer));
        }
      },
    );
  }
}
