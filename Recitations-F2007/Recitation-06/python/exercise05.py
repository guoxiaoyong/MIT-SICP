#!/usr/bin/python

# 
# Working definitions (python)
#
def make_units(C,L,H):
  return [C,L,H]
def get_units_C(x):
  return x[0]
def get_units_L(x):
  return x[1]
def get_units_H(x):
  return x[2]

def make_class(number,units):
  return [number,units]
def get_class_number(x):
  return x[0]
def get_class_units(x):
  return x[1]

def get_class_total_units(klass):
  units = get_class_units(klass)
  return get_units_C(units) + get_units_L(units) + get_units_H(units)

def same_class(klass1,klass2):
  return get_class_number(klass1) == get_class_number(klass2)

#
# Previous Solutions
#
def empty_schedule():
  return []

def add_class(klass,schedule):
  schedule.append(klass)
  return schedule

def total_scheduled_units(schedule):
  def total_scheduled_units_iter(total,working):
    if not working:
      return total
    else:
      return total_scheduled_units_iter(total + get_class_total_units(working[0]), working[1:])
  return total_scheduled_units_iter(0,schedule)

def drop_class(schedule,classnum):
  def predicate(klass):
    return get_class_number(klass) != classnum
  return filter(predicate, schedule)

#
# Exercise 5
#
# Enforce a credit limit by taking in a schedule, and removing classes until
# the total number of units is less than max-credits.
#
def credit_limit(schedule, max_credits):
  def credit_limit_iter(working):
    if not working:
      return []
    else:
      total_credits = total_scheduled_units(working)
      first_class = working[0]
      if ( total_credits > max_credits ):
        return credit_limit_iter(drop_class(working, get_class_number(first_class)))
      else:
        return working
  return credit_limit_iter(schedule)

#
# Run some unit tests:
#
calculus_1 = make_class("CALC-101", make_units(4,4,4))
calculus_2 = make_class("CALC-102", make_units(4,4,4))
algebra = make_class("ALGB-152", make_units(3,3,3))
diff_eqs = make_class("DIFF-201", make_units(3,3,3))

s1 = empty_schedule()
s1 = add_class(calculus_1, s1)
s1 = add_class(calculus_2, s1)
s1 = add_class(algebra, s1)
s1 = add_class(diff_eqs, s1)

#
# Introspect S1:
#
print "Schedule:", s1
# ==> [['CALC-101', [4, 4, 4]], ['CALC-102', [4, 4, 4]], ['ALGB-152', [3, 3, 3]], ['DIFF-201', [3, 3, 3]]]

#
# Total number of units in S1:
#
print "Total Units:", total_scheduled_units(s1)
# ==> 42
print

#
# First test the empty case:
#
print "Credit Limit:", credit_limit(empty_schedule(), 10)
# ==> []

#
# Then test the "do nothing" case:
#
print "Credit Limit:", credit_limit(s1, 50)
# ==> [['CALC-101', [4, 4, 4]], ['CALC-102', [4, 4, 4]], ['ALGB-152', [3, 3, 3]], ['DIFF-201', [3, 3, 3]]]

print "Credit Limit:", credit_limit(s1, 42)
# ==> [['CALC-101', [4, 4, 4]], ['CALC-102', [4, 4, 4]], ['ALGB-152', [3, 3, 3]], ['DIFF-201', [3, 3, 3]]]

print "Credit LImit:", credit_limit(s1, 41)
# ==> [['CALC-102', [4, 4, 4]], ['ALGB-152', [3, 3, 3]], ['DIFF-201', [3, 3, 3]]]

print "Credit Limit:", credit_limit(s1, 25)
# ==> [['ALGB-152', [3, 3, 3]], ['DIFF-201', [3, 3, 3]]]
print 

print "Total Scheduled Units:", total_scheduled_units(credit_limit(s1, 42))
# ==> 42
print "Total Scheduled Units:", total_scheduled_units(credit_limit(s1, 41))
# ==> 30
print "Total Scheduled Units:", total_scheduled_units(credit_limit(s1, 30))
# ==> 30
print "Total Scheduled Units:", total_scheduled_units(credit_limit(s1, 25))
# ==> 18
print

#
# Order of growth in time is O(n^2), where "n" is the length of the "schedule" 
# data structure.  In a worst-case scenario, we need to step through all n 
# elements of the structure, and (again in a worst-case scenario) we may need 
# to invoke the "drop_class" procedure at each step. The precise number of steps
# in this worst-case scenario is n(n+1)/2, or about 1/2 of n^2.
#
# In most cases, though, the algorithm will run much faster than this.
#

#
# [3 --> might be wrong]
# [4 --> might be wrong]
# 