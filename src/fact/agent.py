import os
from google.adk.agents import Agent
# --- IMPORT THE ONLY TOOL WE NEED ---
from google.adk.tools import google_search

# --- Agent Definition ---
# All the old functions (get_weather, get_current_time) are GONE.
#
# The google_search tool will automatically load its keys (GOOGLE_CSE_ID
# and GOOGLE_SEARCH_API_KEY) from the .env file.

root_agent = Agent(
    name="fact_agent", # The name of your agent package
    model="gemini-2.0-flash", # The "brain"
    description=(
        "A general-purpose agent that can answer any question."
    ),
    instruction=(
        "You are a helpful and friendly agent. "
        "You MUST use the google_search tool to find the answer to all user questions. "
        "Provide a clear and concise answer based on the search results."
    ),
    # --- THIS IS THE ONLY TOOL IT HAS ---
    tools=[google_search],
)