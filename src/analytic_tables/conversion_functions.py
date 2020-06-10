import us

# An invalid state will return Null to the database
INVALID_STATE = None


def validate_and_convert_state(state_string: str) -> str:
    """
    Convert string to standard state abbreviation, returns None if there is no valid state in the string
    :param state_string: input string
    :return: Two letter state abbreviation or None
    """
    # Set Null as an empty string
    state_string = state_string if state_string else ''
    # Build dictionary keyed with potential names and with values as capitalized abbreviations
    state_dict = {}
    for state_obj in us.STATES:
        base_abbr = state_obj.abbr

        # Load dictionary with lower case versions of names and abbreviations
        state_dict[base_abbr.lower()] = base_abbr
        state_dict[state_obj.name.lower()] = base_abbr

    # Match lower version of input with dictionary to get valid abbreviation, returning None if it is not in the dictionary
    found_state = state_dict.get(state_string.lower(), INVALID_STATE)
    return found_state
