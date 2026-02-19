@abstract class_name HotelUpgrade extends Resource

# for effects that trigger on apply
@abstract func apply()
## happens when guest checks out. For effects like flat increasing happiness or chance to ignore 
@abstract func checkout_modifier(guest: Guest)

# 25% chance to negate a trait on a guest OR ALL guests give +0.25 stars
# 
# high roller: bonus for getting 4.5 or above BUT penatly for getting below / reduced penalties BUT 25% lower overall gain
