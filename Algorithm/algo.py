import networkx as nx

from datetime import datetime

train_graph = nx.Graph()

stations = ["Station A", "Station B", "Station C", "Station D"]
train_graph.add_nodes_from(stations)

connections = [
    ("Station A", "Station B", {"train_number": "Train 101", "departure_time": "08:00 AM", "arrival_time": "09:30 AM", "status": "On Time"}),
    ("Station B", "Station C", {"train_number": "Train 102", "departure_time": "10:00 AM", "arrival_time": "11:30 AM", "status": "Delayed"}),
    ("Station C", "Station D", {"train_number": "Train 103", "departure_time": "12:00 PM", "arrival_time": "01:30 PM", "status": "On Time"}),
    ("Station A", "Station C", {"train_number": "Train 104", "departure_time": "08:30 AM", "arrival_time": "10:00 AM", "status": "On Time"}),
    ("Station B", "Station D", {"train_number": "Train 105", "departure_time": "11:00 AM", "arrival_time": "12:30 PM", "status": "On Time"})
]

train_graph.add_edges_from(connections)

def find_all_routes(graph, start, end, path=[]):
    path = path + [start]
    if start == end:
        return [path]
    if start not in graph.nodes():
        return []
    routes = []
    for neighbor in graph.neighbors(start):
        if neighbor not in path:
            new_routes = find_all_routes(graph, neighbor, end, path)
            for new_route in new_routes:
                routes.append(new_route)
    return routes


def calculate_minimum_time(graph, route):
    total_time = 0
    for i in range(len(route) - 1):
        edge_data = graph.get_edge_data(route[i], route[i + 1])
        if edge_data is not None:
            departure_time = datetime.strptime(edge_data['departure_time'], '%I:%M %p')
            arrival_time = datetime.strptime(edge_data['arrival_time'], '%I:%M %p')

            time_difference = (arrival_time - departure_time).total_seconds() / 60
            total_time += time_difference
        else:
            print(f"No edge data found between {route[i]} and {route[i + 1]}")
    return total_time



start_station = "Station A"
end_station = "Station D"
all_routes = find_all_routes(train_graph, start_station, end_station)


min_time = float('inf')
min_time_route = None

for route in all_routes:
    current_time = calculate_minimum_time(train_graph, route)
    if current_time < min_time:
        min_time = current_time
        min_time_route = route


print(f"The route with the minimum time between {start_station} and {end_station} is:")
print(" -> ".join(min_time_route))
print(f"Minimum Time: {min_time} minutes")

