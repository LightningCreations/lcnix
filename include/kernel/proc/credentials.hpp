/*
 * credentials.hpp
 *
 *  Created on: Mar. 11, 2020
 *      Author: connor
 */

#ifndef INCLUDE_KERNEL_PROC_CREDENTIALS_HPP_
#define INCLUDE_KERNEL_PROC_CREDENTIALS_HPP_

#include <cstddef>
#include <types.h>

enum class Capability : uint8_t{
#include "caps.inc"
};



struct CapabilitySet{
    constexpr CapabilitySet(unsigned __int128 caps) : caps{caps}{}

private:
	unsigned __int128 caps;

    constexpr static unsigned __int128 as_bit(Capability cap)noexcept{
		return static_cast<unsigned __int128>(1)<<static_cast<unsigned>(cap);
	}
public:
	CapabilitySet()noexcept = default;
	constexpr explicit CapabilitySet(Capability cap)noexcept :
		caps{as_bit(cap)}{}

	// superset of other
	constexpr bool contains(const CapabilitySet& other)const noexcept{
		return (other.caps&this->caps)==other.caps;
	}

	// Element of
	constexpr bool has_capability(Capability cap)const noexcept{
		return caps&as_bit(cap)!=0;
	}

	// subset of
	constexpr bool within(const CapabilitySet& other)const noexcept{
		return (other.caps&this->caps)==other.caps;
	}

	constexpr friend bool operator==(const CapabilitySet& s1,const CapabilitySet& s2){
		return s1.caps==s2.caps;
		// Other s1.within(s2)&&s2,within(s1), by containment
	}

	// Union
	constexpr friend CapabilitySet operator|(const CapabilitySet& s1,const CapabilitySet& s2)noexcept{
		return {s1.caps|s2.caps};
	}
	// Intersection
	constexpr friend CapabilitySet operator&(const CapabilitySet& s1,const CapabilitySet& s2)noexcept{
		return {s1.caps&s2.caps};
	}
	// Set Difference Operator
	constexpr friend CapabilitySet operator-(const CapabilitySet& s1,const CapabilitySet& s2)noexcept{
		return {s1.caps&~s2.caps};
	}

	constexpr CapabilitySet operator~()const noexcept{
		return {~this->caps};
	}
};

constexpr CapabilitySet all_capabilities{~static_cast<unsigned __int128>(0)};
constexpr CapabilitySet no_capabilities{};


// Nothing like a named value type to keep our kernel code typesafe
struct Uid{
	uid_t uid;
	constexpr bool is_root()noexcept{
		return uid==0;
	}
	constexpr CapabilitySet immediate_capabilities()noexcept{
		return uid==0?all_capabilities:no_capabilities;
	}
};

struct Gid{
	gid_t gid;
};


#endif /* INCLUDE_KERNEL_PROC_CREDENTIALS_HPP_ */
